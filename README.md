# Panoramix

> Concurrent programming simulation in C implementing threads, mutexes, and semaphores to manage interactions between villagers and a druid. The project models the consumption and refilling of a magic potion pot to solve complex resource synchronization issues.

---

## Table of Contents
1. [About the Project](#-about-the-project)
2. [Prerequisites](#-prerequisites)
3. [Installation & Compilation](#-installation--compilation)
4. [Usage](#-usage)
5. [Tests](#-tests)
6. [Documentation](#-documentation)

---

## About the Project

**Panoramix** is a simulation modeling a classic synchronization problem (producers/consumers) set in the Asterix universe. 
The druid Panoramix prepares a magic potion pot with a certain capacity. The villagers fight, then come to drink the potion. When the pot is empty, a villager wakes up the druid to refill it.

### Learning Objectives:
- Mastery of the `pthread` library.
- Synchronization with **Mutexes** and **Semaphores**.
- Managing concurrent access to shared resources.
- Prevention of *deadlocks* and *race conditions*.

---

## Prerequisites

- **C Compiler** (e.g., `gcc`, `clang`, `epiclang` configured in the Makefile)
- **Make**
- **Doxygen** (to generate the documentation)

---

## Installation & Compilation

1. Clone this repository or navigate to the project folder.
2. Compile the project using the provided Makefile:

```bash
make
```

The `panoramix` binary will be generated at the root of the project.
To clean object files:
```bash
make clean
```
To remove the binary and object files:
```bash
make fclean
```

---

## Usage

Run the program by passing the following arguments:
```bash
./panoramix <nb_villagers> <pot_size> <nb_fights> <nb_refills>
```
- `nb_villagers`: The number of villagers (must be > 0).
- `pot_size`: The maximum capacity of the pot (must be > 0).
- `nb_fights`: The number of fights each villager must have before stopping (must be > 0).
- `nb_refills`: The number of times the druid can refill the pot before falling asleep for good (must be > 0).

**Example:**
```bash
./panoramix 5 3 4 2
```

---

## Tests

This project contains multiple test suites. You can run them via the `Makefile`:

- **Unit tests**: `make tests_run`
- **Code coverage**: `make coverage`
- **Functional tests**: `make functional`
- **Style tests (Epitech Norm)**: `make style`

---

## Documentation

This project uses **Doxygen** to automatically generate code documentation.

### Generating the documentation

A `doc` rule has been added to the `Makefile` to easily generate the documentation:
```bash
make doc
```

The documentation will be generated in the `docs/` folder. You can then explore it by opening the `docs/html/index.html` file in your web browser:
```bash
xdg-open docs/html/index.html  # On Linux
open docs/html/index.html      # On macOS
```
