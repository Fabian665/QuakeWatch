FROM ghcr.io/astral-sh/uv:python3.14-alpine3.23 AS builder

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_NO_DEV=1

COPY pyproject.toml uv.lock ./

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev --no-install-project

COPY . .

RUN uv sync --frozen --no-dev

FROM python:3.14.5-alpine3.23

WORKDIR /app

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --chown=appuser:appgroup --from=builder /app /app

RUN chown appuser:appgroup /app

ENV QUAKE_PORT="8888"

USER appuser

CMD ["python", "app/main.py"]
