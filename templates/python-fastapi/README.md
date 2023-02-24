# Python 3 Uvicorn/FastAPI Web Application Template

## Dependencies:

- python3
- python3-pip
- (pip) uvicorn
- (pip) fastapi[all]
  - rfc3986
  - websockets
  - uvloop
  - ujson
  - typing-extensions
  - sniffio
  - python-multipart
  - orjson
  - httptools
  - email-validator
  - pydantic
  - anyio
  - watchfiles, 
  - starlette
  - httpcore
  - httpx

To use PostgreSQL:
- postgresql
- (pip) psycopg2

### To run:

- uvicorn main:app --reload --host 0.0.0.0