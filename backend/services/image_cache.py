import httpx
import os
from pathlib import Path
import hashlib

class ImageCacheService:
    def __init__(self, db, cache_dir="static/images"):
        self.db = db
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)

    def _get_cache_path(self, cover_id: str) -> Path:
        """Generate local file path for cached image"""
        return self.cache_dir / f"{cover_id}.jpg"

    async def get_image_url(self, cover_id: str, base_url: str) -> str:
        """
        Get cached image URL or download and cache if not exists.
        Returns relative URL path for serving.
        """
        if not cover_id:
            return ""

        cache_path = self._get_cache_path(cover_id)

        # Check if image is already cached locally
        if cache_path.exists():
            return f"/static/images/{cover_id}.jpg"

        # Check database cache
        cached = await self.db.image_cache.find_one({"cover_id": cover_id})
        if cached and cached.get("local_path"):
            local_path = Path(cached["local_path"])
            if local_path.exists():
                return f"/static/images/{cover_id}.jpg"

        # Download and cache image
        try:
            original_url = f"https://covers.openlibrary.org/b/id/{cover_id}-L.jpg"
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(original_url)
                response.raise_for_status()

                # Save to local file
                cache_path.write_bytes(response.content)

                # Save metadata to database
                await self.db.image_cache.insert_one({
                    "cover_id": cover_id,
                    "local_path": str(cache_path),
                    "original_url": original_url,
                    "size_bytes": len(response.content)
                })

                return f"/static/images/{cover_id}.jpg"

        except Exception as e:
            print(f"Failed to cache image {cover_id}: {e}")
            # Return original URL as fallback
            return f"https://covers.openlibrary.org/b/id/{cover_id}-L.jpg"

    async def batch_cache_images(self, cover_ids: list[str]) -> dict[str, str]:
        """
        Cache multiple images in parallel and return mapping of cover_id to URL.
        """
        import asyncio

        # Filter out empty/None cover_ids
        valid_ids = [cid for cid in cover_ids if cid]

        # Get URLs for all images (will cache if needed)
        tasks = [self.get_image_url(cid, None) for cid in valid_ids]
        urls = await asyncio.gather(*tasks, return_exceptions=True)

        # Build mapping
        result = {}
        for i, cid in enumerate(valid_ids):
            if not isinstance(urls[i], Exception):
                result[cid] = urls[i]
            else:
                # Fallback to original URL
                result[cid] = f"https://covers.openlibrary.org/b/id/{cid}-L.jpg"

        return result
