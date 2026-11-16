# Accessibility

laptop-server is a command-line tool. People use it by reading its output in a terminal and by reading this
documentation. Some of them use a screen reader, a larger terminal font, or the keyboard alone. This page says what
we aim for, what we have checked, what we have not, and how to report a barrier.

## Priorities

- **Plain text output.** Every status is a word: `ok`, `WARN` or `FAIL`. The tool prints no colour codes, so colour
  never carries information.
- **Keyboard only.** The commands take their input from the command line. They have no prompts and no menus.
- **Any terminal width.** Output wraps in a narrow terminal and loses no characters (a word can break across lines).
- **Readable documentation.** Headings in order, a header in every table column, link text that names its target,
  and alternative text for every image.

The Web Content Accessibility Guidelines (WCAG) are written for web content, so we do not claim conformance to them.
We use their documentation criteria as a guide.

## Contributor expectations

If you change the tool or its documentation:

- Run `make check`. Run `python3 .github/scripts/check-docs.py`; the accessibility workflow runs it on every pull request.
- Keep every status readable without colour: keep its word.
- Do not rely on width. Long lines must wrap without losing words.
- Keep documentation headings in order, give every table a header in each column, and write link text that names its target.
- Describe any new dependency in the pull request (see [Dependencies](#dependencies)).

The pull request template lists these as a checklist.

## Reporting accessibility barriers

Open an issue with the [accessibility barrier form](https://github.com/Gooder24/laptop-server/issues/new?template=accessibility.yml).
If the form does not work for you, open a plain issue instead. These details help, when you can share them:

- what you were trying to do, and what went wrong;
- the command and its output, with anything private removed;
- your terminal, operating system and assistive technology, with versions;
- a severity, from the list below.

You do not need to name a disability or explain why a barrier affects you.

### Severity

- **Critical:** a core task cannot be done, for example a command cannot run or its output cannot be read.
- **Serious:** significant difficulty, but a workaround exists.
- **Moderate:** an annoyance, or an inconsistent experience.
- **Minor:** little effect on use.

### How we respond

- We treat each report as useful expertise. We reply with its severity, its owner, its status and the next step.
- Where possible we suggest a workaround while a fix is in progress.
- When the reporter is willing, we ask them to check a fix before the issue is closed.
- We do not ask for medical or disability information.

## Owner

The accessibility owner is [Gooder24](https://github.com/Gooder24), the repository owner. The owner:

- triages accessibility reports and sets their severity;
- keeps the `accessibility` label and the issues that carry it up to date;
- keeps this page current, including the supported environments and known limitations.

## Supported environments

Checked so far:

- Debian 13 with systemd, in a plain terminal (tmux), at 80 and 40 columns, using the keyboard only.
- `make check` and the read-only commands `laptop-server check`, `laptop-server battery` and `laptop-server display status`.

Not checked:

- other distributions, and a fresh install of the package (installing needs root);
- other terminal applications;
- any screen reader (see [Screen reader check](#screen-reader-check)).

## Known limitations

- **The built-in display is dark after the start.** Someone who reads the screen at the machine sees nothing until
  they press `SUPER + D`, which turns the display on. SSH sessions are not affected.
- **`SUPER + D` needs keyd.** The shortcut works only while the `keyd` service runs, and only on a keyboard that
  has a Super key.
- **No screen reader check yet.** The output is plain text, but no screen reader has been run on it.
- **Two documentation barriers are open:** two tables have empty header cells ([#1](https://github.com/Gooder24/laptop-server/issues/1)),
  and some abbreviations are not spelled out at first use ([#2](https://github.com/Gooder24/laptop-server/issues/2)).

## Manual checks

These checks are for the terminal tool and its documentation:

- **Keyboard:** type each command and press Enter. The prompt returns after each one, and no command waits for input.
- **Descriptive language:** each line names the thing it reports, for example `FAIL  the lid does nothing`.
- **Plain language:** the output avoids jargon. Abbreviations in the documentation are spelled out ([#2](https://github.com/Gooder24/laptop-server/issues/2)).
- **Zoom and reflow:** run `laptop-server check` at 40 columns. Every status word and every line appears in full.
- **Colour:** `laptop-server check | grep -c $'\033'` prints `0`, so no colour codes are in the output.

## Documentation checks

- **Structure:** heading levels do not skip (`check-docs.py`).
- **Alternatives:** the repository has no images or videos. `check-docs.py` checks the alternative text of any image added later.
- **Links:** link text is not only "here", "link" or a similar word (`check-docs.py`).
- **Captions:** not applicable, the repository has no video.
- **Tables:** every column has a header. Checked by hand; [#1](https://github.com/Gooder24/laptop-server/issues/1) tracks the two tables that do not.
- **Code blocks:** plain text, with no information carried by colour.

Representative documents, reviewed by hand: `README.md`, `ACCESSIBILITY.md`, `CONTRIBUTING.md` and the templates in `.github/`.

## Keyboard check

Key tasks: `make check`, `laptop-server check`, `laptop-server battery`, `laptop-server display status`.
For each one, type the command, press Enter, and check that the prompt comes back and no step needed a mouse.

## Screen reader check

Not yet run. To run it:

1. Turn on a screen reader for the terminal you use, for example Orca on a Linux desktop.
2. Run `laptop-server check` and listen to the whole output.
3. Check that each line starts with its status word, and that each `WARN` line names the fix (for example `sudo update-grub`).
4. Write the screen reader, its version, the terminal and the operating system in the issue or pull request.

## Dependencies

These dependencies (from the package's `Depends` line) affect what a user sees or types:

- **The terminal.** The tool writes only text, to standard output and standard error. A screen reader or magnifier works
  with whichever terminal you use.
- **`keyd`** remaps the keyboard, so that `SUPER + D` toggles the display. It changes every keyboard it sees, and it
  has not been checked for accessibility.
- **`util-linux`** (`setterm`) turns the console screen off and on. It affects the local console only.

Known upstream barriers: none recorded.

Before a new dependency is added, the pull request says what it does for keyboard and screen reader use, and whether
that was checked.

## Recognition and progress

- Accessibility work will be listed in the release notes once the project has releases.
- Progress is visible in the issues labelled `accessibility`.
- Each contributor is asked how they want to be credited. Personal information and disability information are not
  published without consent.

## Resources

- [`.github/scripts/check-docs.py`](.github/scripts/check-docs.py): a Python script that needs only Python 3 and git. It checks
  Markdown headings, image alternative text and link text. It does not check tables, captions or code blocks, which are
  checked by hand (see Documentation checks). The repository owner maintains it, and it can be copied into other repositories.
- The accessibility barrier form and the pull request checklist in `.github/`.
