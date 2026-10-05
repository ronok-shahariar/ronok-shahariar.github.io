# Ronok Shahariar — Research Portfolio

This repository contains the source code for my personal academic, research, and engineering portfolio website.

## Website

GitHub Pages:

```text
https://ronok-shahariar.github.io/
```

## Main Sections

- About
- Thesis & Reports
- My Projects
- Co-curricular Activities
- CV

## Project Areas

The portfolio includes projects and research related to:

- High-speed networking
- Embedded systems
- DPDK and user-space packet processing
- Software-Defined Radio (SDR)
- FPGA and digital hardware
- VLSI and RTL design
- RISC-V microarchitecture
- Hardware verification
- Wireless communication research

## Technology

The website is built with:

- Jekyll
- GitHub Pages
- HTML
- SCSS
- JavaScript
- Markdown
- Docker

The site is customized from the Academic Pages / Minimal Mistakes Jekyll template.

## Run Locally with Docker

Docker is the only local requirement.

Clone the repository:

```bash
git clone https://github.com/ronok-shahariar/ronok-shahariar.github.io.git
cd ronok-shahariar.github.io
```

Start the website:

```bash
docker compose up --build
```

Then open:

```text
http://localhost:4000
```

Jekyll watches the project files and automatically regenerates the website when content changes.

To stop the local server, press:

```text
Ctrl+C
```

## Build the Website

To perform a standalone Jekyll build:

```bash
docker compose run --rm jekyll-site \
bundle _2.4.19_ exec jekyll build \
--config _config.yml,_config_docker.yml
```

The generated website will be written to:

```text
_site/
```

## Project Structure

```text
_config.yml         Main Jekyll configuration
_config_docker.yml  Docker-specific Jekyll configuration
_pages/             Main website pages
_portfolio/         Engineering and research projects
_publications/      Thesis, reports, and publications
_includes/          Reusable HTML/Liquid components
_layouts/           Page layouts
_sass/              SCSS styles
assets/             JavaScript, CSS, fonts, and other assets
images/             Website images
files/              CV, thesis, reports, and downloadable documents
Dockerfile          Docker environment for Jekyll
docker-compose.yaml Local development configuration
```

## Projects Page

Engineering projects are available through:

```text
/projects/
```

The page combines projects from multiple areas, including:

- Systems & High-Speed Networking
- VLSI & Microarchitecture

Individual project pages remain under the portfolio collection.

## Deployment

The website is hosted using GitHub Pages.

A GitHub Actions workflow also validates that the Jekyll website builds successfully when changes are pushed to the repository.

## License

This project is based on the Academic Pages Jekyll template and the Minimal Mistakes theme.

See the `LICENSE` file for licensing information.