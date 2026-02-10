# Contributing to SMASH

Thanks for your interest in contributing to SMASH!

## How to Contribute

### Reporting Bugs

Found a bug? Please open an issue with:
- SMASH version (`smash --version`)
- Your OS and bash version
- The SMASH code that's causing the issue
- The generated bash code (`smash script.smash --debug`)
- Expected vs actual behavior

### Suggesting Features

Have an idea? Open an issue with:
- Clear description of the feature
- Example SMASH syntax
- Use case / why it's useful
- Expected generated bash code

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly (see Testing below)
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/flaneurette/smash.git
cd smash

# Make the script executable
chmod +x smash

# Test it
./smash examples/hello.smash
```

## Testing

Before submitting a PR, test your changes:

```bash
# Test basic functionality
./smash examples/hello.smash

# Test with debug mode
./smash examples/deploy.smash --debug

# Test all examples
for example in examples/*.smash; do
    echo "Testing $example..."
    ./smash "$example"
done
```

## Code Style

- Use clear variable names
- Add comments for complex regex patterns
- Keep functions focused and small
- Follow existing code style

## Adding New Features

When adding new syntax:

1. Update the transpiler (`transpile_smash()` function)
2. Add examples to `examples/` directory
3. Update `README.md` with the new syntax
4. Test edge cases

Example:

```python
# Adding support for switch/case:

# 1. Add regex pattern in transpile_smash()
code = re.sub(
    r'switch\s*\(\s*(\w+)\s*\)\s*\{',
    r'case "$\1" in',
    code
)

# 2. Create examples/switch.smash
# 3. Document in README.md
# 4. Test!
```

## Questions?

Open an issue or start a discussion. We're happy to help!

## Code of Conduct

Be respectful, inclusive, and constructive. We're all here to make shell scripting better.

---

Thanks for contributing!
