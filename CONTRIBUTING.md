# Contributing to ENTR_RUNTIME

This document describes the procedures and expectations associated with contributing to the ENTR_RUNTIME repository.

## Creating a new release

### Pre-release checklist

Go through the following checklist to make sure that the develop branch reflects the version you'd like to release:

- Make sure you're in the `dev` branch. Merge the open feature branches you'd like into `dev`.
- Review the _GIT_BRANCH arguments at the top of Dockerfile, replacing `dev` branch with a desired tag name, or bumping the version numbers. You may have to create a new release of a dependency.
- Update the changelog.
- Commit these changes to dev.

### Release procedure
Once you are sure that develop contains the code you wish to release, here's the procedure to make a release from dev.

1. `git checkout main`
2. `git merge dev`
3. `git push origin main`
4. `git tag -a v{major}.{minor}.{update}` (where the version number is replaced with the numeric version of this tag)
5. `git push origin v{major}.{minor}.{update}` (where the version number is the same as the tag you just made)
