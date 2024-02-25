# Maintainer Guide

## Adding new distributions

* In `build.sh`, edit all areas marked `# ADD NEW CODENAMES HERE`
* In `generate-files.sh`, edit all areas marked `# ADD NEW CODENAMES HERE`
* Remove everything in `README.md` after
  ```
  | Distribution | 4.9.0 |
  | ------------ | ----- |
  ```
* Run `ci-tests/generate-files.sh`
* 