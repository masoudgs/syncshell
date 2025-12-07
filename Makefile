.PHONY: help install lint lint-fix format test test-cov test-docker clean

help:
	@echo "Available commands:"
	@echo "  make install     Install dependencies"
	@echo "  make lint        Run linter (ruff check)"
	@echo "  make format      Format code (ruff format)"
	@echo "  make test        Run tests with pytest"
	@echo "  make test-cov    Run tests with coverage"
	@echo "  make test-docker Test syncshell installation via pip in Docker"
	@echo "  make clean       Remove build artifacts and cache files"

install:
	poetry install

lint:
	poetry run ruff check .

lint-fix:
	poetry run ruff check . --fix

format:
	poetry run ruff format .

test:
	poetry run pytest

test-cov:
	poetry run pytest --cov=syncshell --cov-report=html --cov-report=term

test-docker:
	@echo "Running Docker Compose test for syncshell..."
	docker-compose -f docker-compose.test.yml up --abort-on-container-exit --exit-code-from syncshell-test
	docker-compose -f docker-compose.test.yml down

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .pytest_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .ruff_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .coverage -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name htmlcov -exec rm -rf {} + 2>/dev/null || true
	rm -rf build/ dist/ *.egg-info/ 2>/dev/null || true
