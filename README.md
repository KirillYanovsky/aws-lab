# Example application

## Pre-commit Hooks

This repo uses [pre-commit hooks](https://pre-commit.com/) for linting, formatting and docs creation before the commit.

### `Setup`

- Install `pre-commit` using instructions [here](https://pre-commit.com/#installation)
- Install required tools

```shell
brew install tflint
brew install terraform-docs
```

- Install the hooks

```shell
pre-commit install
```

### `Usage`

The hooks will run automatically before every commit.  
Updates the docs in each module's `README.md` and fixes formatting and linting with commands such as `terraform fmt`.  
If you want to run the checks manually without committing, use the command

```shell
pre-commit run -a
```
