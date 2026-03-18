# Project Guidelines

## Beta vs Production Architecture

This repo has two deploy targets:
- **Production**: palmdrive.vc (deploys from `master` via `Deploy Production` workflow)
- **Beta**: beta.palmdrive.vc (deploys from `claude/**` branches via `Deploy Beta` workflow to `hendrickPD/website-beta`)

A `Merge to master` workflow auto-merges `claude/**` pushes into `master`, which then triggers production deploy.

### CRITICAL: Never modify source HTML files for beta-only changes

Because changes on `claude/**` branches are auto-merged to `master` and deployed to production, **never bake beta-only modifications (like password gates) directly into source files**. Instead, use the `deploy-beta.yml` workflow's build steps to inject beta-specific changes at deploy time. This keeps production clean.
