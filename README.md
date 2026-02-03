# C/C++ Template Project

![](https://github.com/BigPeet/cxx_template_project/actions/workflows/cmake-multi-platform.yml/badge.svg)

This project aims to serve as a starting point for my C/C++ projects.

The CMake configuration is heavily based on/inspired by [Jason Turner's CMake Template](https://github.com/cpp-best-practices/cmake_template).

## Goals

* An initial directory layout (app, lib, tests, etc.)
* CMake configuration
    * Standard and Language
    * Sanitizers
    * Tests
    * Warnings
    * Options
    * Dependencies
    * Toolchains (TODO)
* Makefile
* clang-tidy, clangd and clang-format configuration
* CI workflows (Github Actions and/or Gitlab config)

## Initialize new Repository from this Template

This repository could be made a [template repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template), but

1. Created repositories would not share the commit history, which would make "merging" with changes from the template more difficult.
2. This approach would only work on Github, not for local repositories or other hosts.

Therefore a more general approach, which keeps the commit history can be used:

1. Create a new empty/bare repository (locally, or on a Git host). For example:

```bash
mkdir /my/new/repo
cd /my/new/repo
git init --bare
```

2. Push branch from this template repository to empty repository. For example:

```bash
cd /path/to/cxx_template_project
git push /my/new/repo master
```

3. Clone the new repository. For example:

```bash
git clone /my/new/repo /my/new/repo_checkout
```
