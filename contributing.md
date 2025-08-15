# Contributing to Deimos

We really appreciate and value contributions to Deimos. Please take time to review the items listed below to make sure that your contributions are merged as soon as possible.

## Contribution guidelines

Before starting development, please [create an issue](https://github.com/BlocSoc-iitr/Deimos/issues/new/choose) to open the discussion, validate that the PR is wanted, and coordinate overall implementation details.

## Creating Pull Requests (PRs)

As a contributor, you are expected to fork this repository, work on your own fork and then submit pull requests. The pull requests will be reviewed and eventually merged into the main repo. See ["Fork-a-Repo"](https://help.github.com/articles/fork-a-repo/) for how this works.

## A typical workflow

1. Make sure your fork is up to date with the main repository:

   ```sh
   cd Deimos
   git remote add origin https://github.com/BlocSoc-iitr/Deimos
   git fetch origin
   git pull --rebase origin dev
   ```

2. Branch out from `dev` into `fix/some-bug-short-description-#123` (ex: `fix/typos-in-docs-#123`):

   (Postfixing #123 will associate your PR with the issue #123 and make everyone's life easier =D)

   ```sh
   git checkout -b fix/some-bug-short-description-#123
   ```

3. Make your changes, add your files.

4. Commit and push to your fork.

   ```sh
   git add src/file.go
   git commit "Fix some bug short description #123"
   git push origin -u fix/some-bug-short-description-#123
   ```

5. Run tests and linter. This can be done by running local continuous integration and make sure it passes.

   ```bash
   cd your-app-location
   cargo fmt --all -- --check
   cargo clippy --all-targets --all-features -- -D warnings
   typos
   ```

6. Go to [Deimos](https://github.com/BlocSoc-iitr/Deimos) in your web browser and issue a new pull request.
   Begin the body of the PR with "Fixes #123" or "Resolves #123" to link the PR to the issue that it is resolving.

7. Maintainers will review your code and possibly ask for changes before your code is pulled in to the main repository. We'll check that all tests pass, review the coding style, and check for general code correctness. If everything is OK, we'll merge your pull request and your code will be part of Deimos.

   _IMPORTANT_ Please pay attention to the maintainer's feedback, since it's a necessary step to keep up with the our standards

## All set

If you have any questions, feel free to post them as an [issue](https://github.com/BlocSoc-iitr/Deimos/issues).

Finally, if you're looking to collaborate and want to find easy tasks to start, look at the issues we marked as ["Good first issue"](https://github.com/BlocSoc-iitr/Deimos/labels/good%20first%20issue).

Thanks for your time and code!