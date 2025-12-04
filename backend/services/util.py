import re

def sanitize_string(string: str):
    string = string.lower().strip()
    string = re.sub(r"\s+", "+", string)
        
    return string


if __name__ == "__main__":
    print(sanitize_string("the    Lord  of the rings"))