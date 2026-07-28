# OpenClaw Desktop

A complete Docker-based desktop environment for **OpenClaw**, featuring a visible Google Chrome browser, noVNC remote access, and Supervisor-managed services.

---

## Overview

OpenClaw Desktop packages OpenClaw together with a lightweight Linux graphical desktop inside a **single Docker container**.

Unlike headless deployments, this project provides a fully visible browser environment that can be accessed remotely using any modern web browser through **noVNC**.

The goal of the project is to provide a reproducible development and testing environment with minimal setup while staying as close as possible to upstream OpenClaw.

OpenClaw continues to manage its own browser profile and Chrome lifecycle. This project only provides the surrounding desktop infrastructure.

---

## Features

* Single Docker container
* Google Chrome with graphical desktop
* Openbox lightweight window manager
* Xvfb virtual display server
* x11vnc remote desktop server
* noVNC browser-based access
* Supervisor-managed services
* Persistent OpenClaw runtime
* Host UID/GID mapping
* Docker health check
* Simple development workflow
* No privileged container required

---

# Architecture

```
                         Host Machine
                               │
                               │
                      Docker Container
                               │
                         entrypoint.sh
                               │
                 Initial container setup
                UID/GID mapping, hooks, etc.
                               │
                         supervisord
                               │
     ┌───────────────┬──────────┼───────────────┬───────────────┐
     │               │          │               │               │
   Xvfb          Openbox      x11vnc         noVNC         OpenClaw
                                                          Gateway
                                                              │
                                                              │
                                                   Google Chrome
                                            (managed by OpenClaw)
```

Supervisor is responsible only for service lifecycle management.

OpenClaw remains responsible for browser management.

---

# Why this project exists

Running OpenClaw with a visible browser normally requires configuring:

* X11
* Window manager
* Chrome
* Remote desktop
* Browser profile persistence
* Container permissions

This repository combines those components into a reusable environment that starts with a single command.

---

# Design Goals

The project was built around a few guiding principles.

## Stay close to upstream

OpenClaw evolves rapidly.

Rather than modifying OpenClaw internals, this project only supplies the desktop environment around it.

This keeps upgrades straightforward.

---

## Single container

Everything runs inside one container.

Advantages:

* Easy deployment
* Simple networking
* Simple persistence
* Easy debugging
* Easy backup

---

## Visible browser

Many AI workflows are much easier to debug when the browser is visible.

Instead of using a headless browser, this project exposes the desktop through noVNC.

---

## Separation of responsibilities

Each component performs one job.

| Component     | Responsibility           |
| ------------- | ------------------------ |
| entrypoint.sh | Container initialization |
| fixuid.sh     | Host UID/GID mapping     |
| supervisord   | Process management       |
| launcher.sh   | Launch OpenClaw          |
| OpenClaw      | Browser lifecycle        |
| Chrome        | Web automation           |

---

# Project Layout

```
openclaw-desktop/

├── config/
│   └── hooks/
│
├── logs/
│
├── openclaw-home/
│
├── workspace/
│
├── scripts/
│   ├── dev.sh
│   ├── entrypoint.sh
│   ├── fixuid.sh
│   ├── launcher.sh
│   └── lib.sh
│
├── supervisor/
│   ├── supervisord.conf
│   └── conf.d/
│
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
```

---

# Runtime Directories

## openclaw-home/

Persistent OpenClaw runtime.

Contains:

* browser profile
* configuration
* agents
* runtime state

This directory should be preserved across container restarts.

---

## workspace/

General workspace shared with OpenClaw.

---

## logs/

Supervisor and service logs.

---

# Requirements

* Docker
* Docker Compose (or docker-compose)
* Linux host
* Google Chrome supported by OpenClaw
* OpenAI-compatible API credentials

---

# Quick Start

Clone the repository.

```
git clone <repository>
cd openclaw-desktop
```

Copy the environment file.

```
cp .env.example .env
```

Edit `.env` and configure your API credentials.

Build the image.

```
make build
```

Start the container.

```
make up
```

Open the desktop.

```
http://localhost:6080
```

OpenClaw Gateway.

```
http://localhost:18789
```

---

# Persistent Data

The following directories are stored on the host.

```
openclaw-home/
workspace/
logs/
```

Deleting these directories removes the associated persistent data.

---

# Development Commands

Build image.

```
make build
```

Start.

```
make up
```

Stop.

```
make down
```

Follow logs.

```
make logs
```

Open shell.

```
make shell
```

Open Supervisor console.

```
make supervisor
```

---

# Supervisor

Supervisor manages all long-running services.

Typical commands:

```
status
restart openclaw
restart xvfb
tail openclaw
tail x11vnc
```

---

# Troubleshooting

## Browser reports profile already in use

Chrome may leave lock files after an unclean shutdown.

Verify no Chrome process is running.

If no process exists, remove the lock files inside the browser profile directory.

Typical files include:

```
SingletonLock
SingletonCookie
SingletonSocket
```

Then restart the browser.

---

## OpenClaw exits immediately

Check:

```
make logs
```

or

```
make supervisor
```

Then inspect the OpenClaw log.

---

## Desktop is blank

Verify Supervisor status.

```
make supervisor
```

Ensure these services are running:

* xvfb
* openbox
* x11vnc
* novnc

---

## Permission problems

This project maps the container user to the host UID/GID during startup.

Normally no manual permission changes should be required.

---

# Updating OpenClaw

Update the OpenClaw image version in the Docker build configuration.

Rebuild the container.

Existing runtime data remains in `openclaw-home/`.

---

# Security Notes

This environment is intended primarily for local development and trusted networks.

Before exposing the gateway to external networks:

* Configure authentication.
* Protect the container behind a reverse proxy if appropriate.
* Restrict firewall access.
* Protect any exposed VNC endpoints.

---

# Known Limitations

* Chrome profile lock files may remain after an unclean shutdown.
* This project targets Linux hosts.
* OpenClaw runtime directory must be initialized for first use.

---

# Acknowledgements

This project builds upon the excellent work of the OpenClaw community.

Special thanks to everyone contributing to OpenClaw and the surrounding open-source ecosystem.

---

# License

This project is released under the MIT License.

See the LICENSE file for details.

