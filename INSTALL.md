# Install stitch-landing

<details>
<summary><strong>Claude Code</strong></summary>

### Install

```bash
claude plugin marketplace add cskwork/stitch-landing-skill
claude plugin install stitch-landing@stitch-landing
```

Type `/stitch-landing`.

### Verify

```bash
claude plugin list
```

### Update

```bash
claude plugin marketplace update stitch-landing
```

### Uninstall

```bash
claude plugin uninstall stitch-landing
claude plugin marketplace remove stitch-landing
```

</details>

<details>
<summary><strong>Codex</strong></summary>

### Install

```bash
codex plugin marketplace add cskwork/stitch-landing-skill --ref main
codex plugin add stitch-landing@stitch-landing
```

Type `$stitch-landing`.

### Verify

```bash
codex plugin list
```

### Uninstall

```bash
codex plugin remove stitch-landing
codex plugin marketplace remove stitch-landing
```

</details>

<details>
<summary><strong>Gemini CLI</strong></summary>

### Install (extension, always-on)

```bash
gemini extensions install https://github.com/cskwork/stitch-landing-skill
```

### Install (command, opt-in)

```bash
mkdir -p ~/.gemini/commands
curl -fsSL https://raw.githubusercontent.com/cskwork/stitch-landing-skill/main/skills/stitch-landing-skill/agents/gemini.toml \
  -o ~/.gemini/commands/stitch-landing.toml
```

Type `/stitch-landing` in a new session.

### Verify

```bash
gemini extensions list
```

### Uninstall

```bash
gemini extensions uninstall stitch-landing
```

</details>

<details>
<summary><strong>Cursor, OpenCode, Amp, and other agent-skills harnesses</strong></summary>

### Install

```bash
npx skills add cskwork/stitch-landing-skill
npx skills add cskwork/stitch-landing-skill -g
```

Type `/stitch-landing` in a new agent chat.

### Verify

```bash
npx skills list
```

### Update

```bash
npx skills update stitch-landing
```

### Uninstall

```bash
npx skills remove stitch-landing
```

</details>

<details>
<summary><strong>Antigravity (agy)</strong></summary>

### Install

```bash
agy plugin install https://github.com/cskwork/stitch-landing-skill
```

### Verify

```bash
agy plugin list
```

### Uninstall

```bash
agy plugin uninstall stitch-landing
```

</details>
