# DAP + Pytest: Break on Failure Setup

## Current Setup

I've configured DAP to attempt breaking on test failures like `pytest --pdb`. However, **debugpy (the Python debug adapter) has limitations** with breaking on AssertionError.

## Commands Available

| Command | What It Does |
|---------|--------------|
| `<leader>dpb` | **Break on Failure mode** - Attempts to break when test fails |
| `<leader>dpt` | Debug single test method |
| `<leader>dpf` | Debug all tests in file |

## The Problem

**debugpy doesn't reliably break on AssertionError** because:
1. pytest catches the AssertionError internally
2. debugpy sees it as "handled" and doesn't break
3. This is a known limitation of debugpy vs pdb

## Workarounds (Choose One)

### ✅ Option 1: Manual Breakpoint Strategy (Recommended)

**Best for**: When you know which test is failing

1. Set a breakpoint (`<leader>db`) on the line BEFORE the assertion
2. Run `<leader>dpt` to debug the test
3. When it stops, step over (`<leader>do`) to see the failure
4. Inspect variables in the failure state

**Example:**
```python
def test_addition():
    result = add(2, 2)
    # Set breakpoint here with <leader>db
    assert result == 5  # Step over this to see failure
```

### ✅ Option 2: Use pytest.set_trace()

**Best for**: Quick debugging without configuring DAP

Add this line before your assertion:
```python
import pytest

def test_addition():
    result = add(2, 2)
    pytest.set_trace()  # <-- Add this
    assert result == 5
```

Then run `<leader>dpt` - it will stop at `set_trace()`.

### ✅ Option 3: Wrap Assertions in try/except

**Best for**: Catching failure in complex tests

```python
def test_addition():
    result = add(2, 2)
    try:
        assert result == 5
    except AssertionError:
        breakpoint()  # <-- Set breakpoint here with <leader>db
        raise
```

### ✅ Option 4: Use conftest.py Hook

**Best for**: Project-wide break-on-failure

Create `conftest.py` in your project root:

```python
# conftest.py
import pytest

@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    rep = outcome.get_result()

    if rep.when == "call" and rep.failed:
        # Break here when test fails
        import pdb; pdb.set_trace()
```

Then run tests normally with `<leader>dpt`.

### ⚠️ Option 5: Use pytest --pdb in Terminal

**Best for**: When DAP integration doesn't work

Run in terminal:
```bash
pytest -x --pdb tests/test_file.py::test_method
```

This gives you true `pytest --pdb` behavior.

## My Recommendation

**For everyday debugging**, use **Option 1** (manual breakpoints):

1. Identify the failing test
2. Set breakpoint with `<leader>db` on the line before assertion
3. Run `<leader>dpt`
4. Step through and inspect

This gives you:
- ✅ Full DAP UI integration
- ✅ Visual variable inspection
- ✅ REPL access with `<leader>dr`
- ✅ No code changes needed

## What I've Configured

Your DAP setup includes:
- `<leader>dpb` - Attempts break-on-failure (may not work for AssertionError)
- Exception breakpoints enabled
- DAP UI stays open on failure
- Console output visible
- REPL available

## Testing the Setup

Try this test to see if `<leader>dpb` works:

```python
# test_break.py
def test_exception():
    raise ValueError("This should break!")

def test_assertion():
    assert 1 == 2, "This might not break automatically"
```

- `<leader>dpb` on `test_exception` → **Should break** ✅
- `<leader>dpb` on `test_assertion` → **Might not break** ⚠️

For `test_assertion`, use Option 1 (manual breakpoint).

## Future Solutions

If you want true `pytest --pdb` behavior integrated into DAP:
1. Wait for debugpy to support breaking on "handled" exceptions
2. Use a pytest plugin that integrates with debugpy
3. Contribute to nvim-dap-python to add this feature

For now, **manual breakpoints + DAP UI** is the best workflow. 🎯
