FROM ghcr.io/astral-sh/uv:python3.12-trixie-slim AS builder

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_NO_DEV=1

COPY pyproject.toml uv.lock ./

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev --no-install-project

COPY . .

RUN uv sync --frozen --no-dev

FROM python:3.12-slim-trixie

WORKDIR /app

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

COPY --from=builder /app /app

RUN useradd --create-home appuser \
    && chown -R appuser /app

USER appuser

CMD ["python", "main.py"]
