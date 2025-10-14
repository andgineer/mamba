# Repository Guidelines

## Project Structure & Module Organization
- `Dockerfile` builds the Mamba-based runtime, configures proxies, and provisions the condensed scientific stack.
- `environment.yml` pins the conda env (`mamba`) and packages; keep dependencies minimal and alphabetized when possible.
- `.github/workflows/dockerhub.yml` defines the multi-arch build pipeline, tag generation, and automatic GitHub releases.
- `README.md` and `CLAUDE.md` document container usage and collaboration notes; update them when workflows or image behavior change.

## Build, Test, and Development Commands
- `docker build -t andgineer/mamba-local .` compiles the image against the current `environment.yml` and Dockerfile.
- `docker run --rm -it andgineer/mamba-local python --version` validates the Python version baked into the env.
- `docker run --rm andgineer/mamba-local bash -lc "mamba --version"` confirms mamba availability before tagging a release.
- For multi-arch parity, use `docker buildx build --platform linux/amd64,linux/arm64 -t andgineer/mamba-local . --load` when Buildx is enabled locally.

## Coding Style & Naming Conventions
- Keep Dockerfile instructions grouped by concern (user setup, conda configuration, environment creation) and favor explicit shell pipelines.
- Mirror GitHub Action env var casing (e.g., `DEFAULT_PYTHON`) and align new build args with existing `ARG` naming.
- Maintain YAML indentation at two spaces and quote strings that will be interpolated by GitHub Actions.
- When adding packages, prefer conda-forge channel compatibility; note pip-only dependencies under a `pip:` subsection.

## Testing Guidelines
- After modifying dependencies, rebuild locally and run `docker run --rm andgineer/mamba-local conda list` to confirm resolved versions.
- For workflow updates, execute `act -j build` if GitHub Actions parity is required, or at minimum run `docker build` once per targeted Python version.
- Document manual validation steps in PR descriptions whenever automated coverage is unavailable.

## Commit & Pull Request Guidelines
- Follow the short, imperative commit style seen in history (e.g., `fix release name`).
- Reference issue IDs when applicable and keep commits logically scoped to Dockerfile, env, or workflow changes.
- PRs should summarize image changes, list new tags or dependency bumps, and attach test/build output snippets for reviewers.
- For release automation tweaks, call out expected artifact names so maintainers can verify GitHub Actions results.

## CI & Release Notes
- The `dockerhub` workflow builds matrices for Python 3.12 and 3.13, generates tags, and publishes GitHub releases on `master` pushes.
- Coordinate manual releases by supplying `workflow_dispatch` inputs only after confirming the default matrix builds locally.
- Review uploaded `/tmp/versions` artifacts in the workflow run to confirm detected Mamba versions before promoting tags publicly.
