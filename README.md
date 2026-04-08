# Backup your GitHub repos

**One line to clone them all.**

![Banner Image](/img/artemis_moon.jpg "The dark side of the moon. An Artemis view")

*No CGI. Thank you [NASA](https://www.flickr.com/photos/nasahqphoto/)!*

`gh-clone-all` is a small Debian package that clones public repos locally for a specified GitHub username.

## Genesis

> This script started as the challenge to code a small shell one-liner, and avoid the hassle of manually copying each clone URL. Created to quickly mirror or back up all public repositories for a GitHub account without manually copying each clone URL when migrating systems. It eventually just grew into a full, reusable package.

## Table of contents

<details>
<summary>Contents - click to expand</summary>

- [Backup your GitHub repos](#backup-your-github-repos)
  - [Genesis](#genesis)
  - [Table of contents](#table-of-contents)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Project layout](#project-layout)
  - [What the tool does](#what-the-tool-does)
  - [Installation and usage: the easy way](#installation-and-usage-the-easy-way)
    - [Using the standalone script only](#using-the-standalone-script-only)
    - [Build the `.deb` by yourself](#build-the-deb-by-yourself)
      - [Install the package](#install-the-package)
      - [Run the tool](#run-the-tool)
        - [Example output](#example-output)
  - [Limitations](#limitations)
  - [Improvements](#improvements)
  - [License](#license)
  - [And for the beauty of the view](#and-for-the-beauty-of-the-view)

</details>

## Features

- Prompts for a GitHub username if not provided via command-line arguments.
- Lists the user’s public repositories via the GitHub REST API.
- Clones each repository with `git clone`.
- Packaged as a `.deb` for easy installation on Debian-based systems.

## Requirements

Debian or Ubuntu-based system.

- `curl`
- `git`
- `awk`
- `grep`
- `sed`
- `xargs` found in `findutils`

These dependencies are included in the package metadata so they are installed automatically when possible.

## Project layout

```text
clone-github-user-repos/
├── img/
├── src/
|   ├── build.sh
|   └── gh-clone-all_script.sh
├── install_gh-clone-all.sh
└── README.md

.deb Package structure
└── gh-clone-all_1.0.0_all/
    ├── DEBIAN/
    │   └── control
    └── usr/
        └── bin/
            └── gh-clone-all
```

## What the tool does

The script asks for a GitHub username (if not specified in CLI arguments), calls the GitHub REST API for that user’s repositories ((JSON) with per_page=100), extracts each repository’s `clone_url`, and runs `git clone` for every result.

> [!NOTE]
> GitHub’s repository listing API is paginated, and the `per_page` parameter supports up to 100 results per page, so accounts with more than 100 repositories will need pagination support (not implemented) if you want every repository cloned.

## Installation and usage: the easy way

Just run the command below under Ubuntu/Debian and wait for the script to execute.

- Download and execute the installation script:

```bash
curl -sL https://raw.githubusercontent.com/brooks-code/clone-github-user-repos/main/install_gh-clone-all.sh | bash
```

### Using the standalone script only

If you prefer just running the scriplet without installation, the script is located in the `src` folder.

- Pass a substitution before running:

```bash
USERNAME=octocat ./gh-clone-all_script.sh          
```

- Or edit the URL to include your username directly in the script

```bash
# Replace the USERNAME
curl -s "https://api.github.com/users/USERNAME/repos?per_page=100" \
...
```

### Build the `.deb` by yourself

Make the build script executable and run it:

```bash
chmod +x build.sh
./build.sh
```

This will create a file named similar to:

```text
gh-clone-all_1.0.0_all.deb
```

The `.deb` is created from a directory tree that contains a `DEBIAN` metadata directory and the files to be installed into the target filesystem.

#### Install the package

Install the local package with `apt`:

```bash
sudo apt install ./gh-clone-all_1.0.0_all.deb
```

You can also use `dpkg -i`, but `apt` is often preferred for local `.deb` installs (because it can resolve dependencies more conveniently).

#### Run the tool

After a succesfull installation, run:

```bash
gh-clone-all octocat
```

or

```bash
gh-clone-all
```

and when prompted, enter a GitHub username such as:

```text
octocat
```

The script will then clone that user’s public repositories into the current directory.

##### Example output

```bash
$ github-clone-all
Enter GitHub username: octocat
Cloning into 'Spoon-Knife'...
Cloning into 'Hello-World'...
```

## Limitations

> [!NOTE]
> This clones up to 100 repos. pagination support for more is note implemented (yet).
>
> The command targets **public repositories** by default. Use authenticated endpoints to access private repos.

And last but not least..

- Be mindful of GitHub API **rate limits** for unauthenticated requests.
- Cloning many repos can consume significant disk space and network bandwidth.

## Improvements

Possible improvements include:

- [ ] Adding pagination support for users with large numbers of repositories.
- [ ] Option to filter out forks or archived repositories.
- [X] Adding a username command-line option alongside interactive prompting.

## License

The source code is provided under the [Unlicense](https://unlicense.org/) license. See the [LICENSE](/LICENSE) file for details.

## And for the beauty of the view

![Banner Image](/img/crescent_earth.jpg "Earthrise.")

*Just to [see](https://ucly.hal.science/hal-05184143v1) the [view](https://chopplet.canalblog.com/archives/2024/01/02/40162097.html). Thank you [NASA](https://www.flickr.com/photos/nasahqphoto/)!*
