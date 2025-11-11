# Java Development Guide for Neovim

Comprehensive documentation for Java development tools and Neovim plugins, including installation, configuration, compatibility notes, and example workflows.

## Table of Contents

1. [Java Version Compatibility](#java-version-compatibility)
2. [nvim-java Plugin](#nvim-java-plugin)
3. [jdtls (Eclipse JDT Language Server)](#jdtls-eclipse-jdt-language-server)
4. [nvim-dap for Java Debugging](#nvim-dap-for-java-debugging)
5. [Testing with Neotest](#testing-with-neotest)
6. [Code Formatting](#code-formatting)
7. [Build Tool Integrations](#build-tool-integrations)
8. [Treesitter Java Support](#treesitter-java-support)
9. [Example Workflows](#example-workflows)

---

## Java Version Compatibility

### Critical Version Information

**jdtls Requirements:**
- **Runtime Environment**: Java 21 minimum required to run the language server
- **Project Support**: Can compile and work with Java projects from 1.8 through Java 24
- **Key Insight**: jdtls runs on Java 21+ but can manage projects using different JDK versions

**Current Limitation (as of your config):**
- Your system uses Java 24
- jdtls is DISABLED in your config because of this
- Treesitter works fine with Java 24 (syntax highlighting only)

**Solutions:**
1. **Recommended**: Install Java 21 alongside Java 24
   - Use Java 21 to run jdtls (via JAVA_HOME or PATH)
   - Keep Java 24 for your projects
   - jdtls will detect and use Java 24 for your project compilation
2. **Alternative**: Wait for jdtls to officially support Java 24 runtime

### Execution Environment Configuration

jdtls supports configuring multiple Java runtimes:

```typescript
interface RuntimeOption {
  name: ExecutionEnvironment;  // e.g., "JavaSE-21", "JavaSE-24"
  path: string;                 // Path to JDK installation
  javadoc?: string;             // Optional javadoc location
  sources?: string;             // Optional source location
  default?: boolean;            // Set as default runtime
}
```

**Supported Execution Environments:**
- J2SE-1.5 through JavaSE-22
- Your project can use any of these even if jdtls runs on Java 21

---

## nvim-java Plugin

### Overview

**nvim-java** provides "Painless Java in Neovim" by wrapping jdtls with additional features:
- Automatic installation and configuration of jdtls
- Integration with java-test and java-debug-adapter extensions
- Simplified setup compared to manual jdtls configuration

**Repository**: `nvim-java/nvim-java`

### Installation (Lazy.nvim)

```lua
{
  "nvim-java/nvim-java",
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    {
      "williamboman/mason.nvim",
      opts = {
        registries = {
          "github:nvim-java/mason-registry",
          "github:mason-org/mason-registry",
        },
      },
    },
  },
  ft = "java",  -- Load only for Java files
}
```

### Minimal Configuration

```lua
{
  "nvim-java/nvim-java",
  ft = "java",
  config = function()
    require("java").setup()
  end,
}

-- Then in your lspconfig setup:
{
  "neovim/nvim-lspconfig",
  config = function()
    require("lspconfig").jdtls.setup({})
  end,
}
```

### Key Features

1. **Auto-installation**: Downloads and configures jdtls via Mason
2. **Test Integration**: Built-in support for JUnit via java-test extension
3. **Debug Support**: Integrates java-debug-adapter with nvim-dap
4. **Hot Code Replace**: Live code updates during debugging
5. **Spring Boot Support**: Specialized configurations for Spring projects

### Important Note

**You CANNOT use nvim-java alongside nvim-jdtls** - they are mutually exclusive. Choose one:
- **nvim-java**: "Batteries included" approach, less configuration
- **nvim-jdtls**: "Keep it simple, stupid" - more manual control

---

## jdtls (Eclipse JDT Language Server)

### Overview

**Eclipse JDT Language Server** is the official Java language server implementing the Language Server Protocol (LSP).

**Repository**: `eclipse-jdtls/eclipse.jdt.ls`

### Installation via Mason

```vim
:Mason
```

Search for and install:
- `jdtls` - The language server itself
- `java-debug-adapter` - For debugging support
- `java-test` - For test discovery and execution

**Command-line installation:**
```bash
nvim --headless -c "MasonInstall jdtls java-debug-adapter java-test" -c qall
```

### Manual Installation via nvim-jdtls

If you prefer the nvim-jdtls plugin for manual control:

```lua
{
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
}
```

### Configuration for Java 21

**Important**: Set JAVA_HOME to Java 21 before launching Neovim:

```bash
export JAVA_HOME=/path/to/java-21
nvim
```

**Or in your Neovim config:**

```lua
-- In after/ftplugin/java.lua
local jdtls = require("jdtls")

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

local config = {
  cmd = {
    "java",  -- Uses Java from PATH or JAVA_HOME
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_" .. (vim.fn.has("mac") == 1 and "mac" or "linux"),
    "-data", workspace_dir,
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
  settings = {
    java = {
      home = "/path/to/java-21",  -- Explicit Java 21 path
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/path/to/java-21",
            default = true,
          },
          {
            name = "JavaSE-24",
            path = "/path/to/java-24",
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.junit.Assert.*",
        "org.junit.Assume.*",
        "org.junit.jupiter.api.Assertions.*",
        "org.junit.jupiter.api.Assumptions.*",
        "org.junit.jupiter.api.DynamicContainer.*",
        "org.junit.jupiter.api.DynamicTest.*",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org",
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },
  init_options = {
    bundles = {},  -- Add java-debug and java-test bundles here (see debugging section)
  },
}

-- Setup jdtls
jdtls.start_or_attach(config)
```

### Key Settings Explained

**updateBuildConfiguration**: How jdtls responds to changes in `pom.xml` or `build.gradle`
- `"interactive"` (default): Prompts you to update
- `"automatic"`: Auto-updates classpath
- `"disabled"`: Never updates

**runtimes**: Configure multiple JDK versions
- Your jdtls runs on Java 21
- Your project can compile with Java 24
- jdtls auto-detects which runtime to use per project

**completion.favoriteStaticMembers**: Auto-import suggestions for common test frameworks

**sources.organizeImports**: Control when to use wildcard imports
- `starThreshold: 9999` means almost never use `import java.util.*`
- Keeps imports explicit

---

## nvim-dap for Java Debugging

### Overview

**nvim-dap** provides Debug Adapter Protocol support for Neovim. For Java, you need the `java-debug-adapter` extension.

### Installation

```lua
{
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "nvim-java/nvim-java",  -- If using nvim-java
  },
}
```

**Via Mason:**
```vim
:MasonInstall java-debug-adapter java-test
```

### Java Debug Configuration (Manual Setup)

If using nvim-jdtls, you need to load the debug bundles:

```lua
-- In after/ftplugin/java.lua
local bundles = {
  vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar", 1), "\n"))

-- Add bundles to jdtls config:
config.init_options = {
  bundles = bundles,
}

-- After jdtls starts:
jdtls.start_or_attach(config)

-- Setup dap configurations
local dap = require("dap")
dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Debug (Launch) - Current File",
    mainClass = "${file}",
  },
  {
    type = "java",
    request = "launch",
    name = "Debug (Launch) with Arguments",
    mainClass = "${file}",
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " ")
    end,
  },
  {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

-- Define the Java debug adapter
dap.adapters.java = function(callback)
  -- Trigger the jdtls command to start debug session
  require("jdtls").start_debug_session(callback)
end
```

### Common Debug Keymaps

Add to your dap.lua or keymaps:

```lua
-- Toggle breakpoint
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle Breakpoint" })

-- Continue/Start debugging
vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<cr>", { desc = "Continue" })

-- Step into
vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<cr>", { desc = "Step Into" })

-- Step over
vim.keymap.set("n", "<leader>do", "<cmd>DapStepOver<cr>", { desc = "Step Over" })

-- Step out
vim.keymap.set("n", "<leader>dO", "<cmd>DapStepOut<cr>", { desc = "Step Out" })

-- Terminate
vim.keymap.set("n", "<leader>dt", "<cmd>DapTerminate<cr>", { desc = "Terminate" })

-- Toggle DAP UI
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
```

### JUnit Test Debugging

With nvim-jdtls, you can debug individual tests:

```lua
-- Debug nearest test method
vim.keymap.set("n", "<leader>djt", function()
  require("jdtls").test_nearest_method()
end, { desc = "Debug Test Method" })

-- Debug entire test class
vim.keymap.set("n", "<leader>djc", function()
  require("jdtls").test_class()
end, { desc = "Debug Test Class" })
```

### Hot Code Replace

jdtls supports hot code replacement during debugging:

1. Set breakpoint in a method
2. Start debugging (`<leader>dc`)
3. When paused at breakpoint, edit the code
4. Save the file
5. jdtls will automatically reload the changed method
6. Continue execution with the new code

**Limitations:**
- Cannot add/remove methods
- Cannot change class structure
- Only method body changes supported

---

## Testing with Neotest

### neotest-java Adapter

**neotest-java** provides JUnit test integration for Neotest.

**Repository**: `rcasia/neotest-java` (primary) or `andy-bell101/neotest-java`

### Installation

```lua
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "rcasia/neotest-java",  -- Java adapter
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-java")({
          -- Defaults to downloading JUnit standalone jar from Maven Central
          junit_jar = vim.fn.stdpath("data") .. "/neotest-java/junit-platform-console-standalone-1.10.1.jar",

          -- Enable incremental builds (faster for large projects)
          incremental_build = true,
        }),
      },
    })
  end,
}
```

### Requirements

1. **Treesitter Java Parser**: Install with `:TSInstall java`
2. **nvim-jdtls** or **nvim-java**: For LSP support
3. **JUnit 5**: Your project should use JUnit 5 (Jupiter)

### Usage

**Run nearest test:**
```vim
:lua require("neotest").run.run()
```

**Run entire file:**
```vim
:lua require("neotest").run.run(vim.fn.expand("%"))
```

**Run entire test suite:**
```vim
:lua require("neotest").run.run(vim.fn.getcwd())
```

**Debug nearest test:**
```vim
:lua require("neotest").run.run({strategy = "dap"})
```

**View test output:**
```vim
:lua require("neotest").output.open()
```

**Toggle test summary:**
```vim
:lua require("neotest").summary.toggle()
```

### Keymaps for Neotest

```lua
local neotest = require("neotest")

vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end, { desc = "Run Nearest Test" })
vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run File Tests" })
vim.keymap.set("n", "<leader>ta", function() neotest.run.run(vim.fn.getcwd()) end, { desc = "Run All Tests" })
vim.keymap.set("n", "<leader>td", function() neotest.run.run({strategy = "dap"}) end, { desc = "Debug Test" })
vim.keymap.set("n", "<leader>to", function() neotest.output.open() end, { desc = "Show Test Output" })
vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle Test Summary" })
vim.keymap.set("n", "<leader>tw", function() neotest.watch.toggle() end, { desc = "Watch Tests" })
```

### Alternative: neotest-gradle

For Gradle-based projects (Kotlin and Java):

```lua
{
  "weilbith/neotest-gradle",
}

-- In neotest setup:
adapters = {
  require("neotest-gradle")({
    gradle_command = "./gradlew",  -- or "gradle"
  }),
}
```

---

## Code Formatting

### google-java-format

**google-java-format** is Google's official Java formatter following Google's Java Style Guide.

### Installation via Mason

```vim
:MasonInstall google-java-format
```

### Setup with conform.nvim (Recommended)

```lua
{
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters = {
      ["google-java-format"] = {
        -- Use AOSP style (4 spaces instead of 2)
        prepend_args = { "--aosp" },
      },
    },
  },
}
```

**Style Options:**
- Default: 2-space indentation (Google style)
- `--aosp`: 4-space indentation (Android Open Source Project style)

### Setup with none-ls (null-ls fork)

**Note**: null-ls is archived; use `nvimtools/none-ls.nvim`

```lua
{
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.google_java_format.with({
          extra_args = { "--aosp" },  -- 4-space indentation
        }),
        null_ls.builtins.diagnostics.checkstyle.with({
          extra_args = { "-c", "/google_checks.xml" },  -- Google style checks
        }),
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    require("mason-null-ls").setup({
      ensure_installed = { "google-java-format", "checkstyle" },
      automatic_installation = true,
    })
  end,
}
```

### Manual Formatting

Format current buffer:
```vim
:lua vim.lsp.buf.format()
```

Or with conform.nvim:
```vim
:ConformInfo  " Check formatter status
:Format       " Format buffer
```

### Checkstyle Integration

For linting alongside formatting:

```bash
# Via Mason
:MasonInstall checkstyle
```

**With none-ls:**
```lua
null_ls.builtins.diagnostics.checkstyle.with({
  extra_args = {
    "-c", "/usr/share/checkstyle/google_checks.xml",  -- Or sun_checks.xml
  },
}),
```

---

## Build Tool Integrations

### Maven Integration

jdtls has built-in Maven support:

```lua
-- In jdtls settings
settings = {
  java = {
    maven = {
      downloadSources = true,
      userSettings = "~/.m2/settings.xml",  -- Optional custom settings
    },
    import = {
      maven = {
        enabled = true,
      },
    },
    configuration = {
      updateBuildConfiguration = "interactive",  -- Prompt on pom.xml changes
    },
  },
}
```

**Manually trigger Maven import:**
```vim
:lua require("jdtls").update_projects_config()
```

### Gradle Integration

jdtls supports Gradle projects:

```lua
settings = {
  java = {
    import = {
      gradle = {
        enabled = true,
      },
    },
    gradle = {
      home = "/path/to/gradle",  -- Optional
      wrapper = {
        enabled = true,
      },
      offline = {
        enabled = false,
      },
    },
  },
}
```

### overseer.nvim Task Templates

Create custom build tasks with overseer.nvim:

```lua
{
  "stevearc/overseer.nvim",
  opts = {
    templates = {
      "builtin",
      "user.maven_compile",
      "user.maven_test",
      "user.gradle_build",
    },
  },
}
```

**User template example** (`~/.config/nvim/lua/overseer/template/user/maven_compile.lua`):

```lua
return {
  name = "Maven Compile",
  builder = function()
    return {
      cmd = { "mvn" },
      args = { "compile" },
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "java" },
  },
}
```

**Run tasks:**
```vim
:OverseerRun
:OverseerToggle  " View task panel
```

### Direct Shell Commands

For simple builds without a task runner:

```lua
-- Maven compile
vim.keymap.set("n", "<leader>mc", ":!mvn compile<CR>", { desc = "Maven Compile" })

-- Maven test
vim.keymap.set("n", "<leader>mt", ":!mvn test<CR>", { desc = "Maven Test" })

-- Gradle build
vim.keymap.set("n", "<leader>gb", ":!./gradlew build<CR>", { desc = "Gradle Build" })

-- Gradle test
vim.keymap.set("n", "<leader>gt", ":!./gradlew test<CR>", { desc = "Gradle Test" })
```

---

## Treesitter Java Support

### Installation

```vim
:TSInstall java
```

Or in your config:

```lua
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "java",
        "kotlin",  -- If you also use Kotlin
        -- ... other languages
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    })
  end,
}
```

### Java 24 Compatibility

**Treesitter parser works with Java 24 syntax** including:
- Pattern matching for switch
- Record patterns
- Sealed classes
- Text blocks
- Recent language features

**Note**: While jdtls doesn't run on Java 24, Treesitter provides excellent syntax highlighting and code navigation without LSP.

### Treesitter Features for Java

1. **Syntax Highlighting**: Semantic highlighting for classes, methods, variables
2. **Code Navigation**:
   - `[[` / `]]`: Jump to previous/next class
   - `[m` / `]m`: Jump to previous/next method
3. **Incremental Selection**: Expand selection to AST nodes
4. **Indentation**: Automatic indentation based on syntax tree

---

## Example Workflows

### Workflow 1: Setting Up Java 21 + Java 24

**Goal**: Run jdtls on Java 21 while developing Java 24 projects

**Steps:**

1. **Install Java 21 and Java 24**:
   ```bash
   # macOS (Homebrew)
   brew install openjdk@21
   brew install openjdk@24

   # Linux (SDKMAN)
   sdk install java 21.0.1-open
   sdk install java 24-open
   ```

2. **Configure jdtls to run on Java 21**:
   ```bash
   # Set JAVA_HOME for jdtls
   export JAVA_HOME=/opt/homebrew/opt/openjdk@21
   ```

3. **Configure multiple runtimes in jdtls**:
   ```lua
   -- In after/ftplugin/java.lua
   settings = {
     java = {
       configuration = {
         runtimes = {
           {
             name = "JavaSE-21",
             path = "/opt/homebrew/opt/openjdk@21",
             default = true,
           },
           {
             name = "JavaSE-24",
             path = "/opt/homebrew/opt/openjdk@24",
           },
         },
       },
     },
   }
   ```

4. **Specify project Java version** in `pom.xml`:
   ```xml
   <properties>
     <maven.compiler.source>24</maven.compiler.source>
     <maven.compiler.target>24</maven.compiler.target>
   </properties>
   ```

5. **Verify setup**:
   - jdtls runs on Java 21
   - Your project compiles with Java 24
   - LSP features work correctly

### Workflow 2: Debugging a JUnit Test

**Goal**: Debug a failing JUnit test with breakpoints

**Steps:**

1. **Open test file** (`src/test/java/com/example/MyTest.java`)

2. **Set breakpoint** on the failing assertion:
   - Move cursor to the line
   - Press `<leader>db`

3. **Start debugging**:
   - Option A (nvim-jdtls): `<leader>djt` (debug test method)
   - Option B (neotest): `:lua require("neotest").run.run({strategy = "dap"})`

4. **Inspect variables**:
   - DAP UI opens automatically
   - View local variables, stack trace, watches

5. **Step through code**:
   - `<leader>di`: Step into method
   - `<leader>do`: Step over line
   - `<leader>dO`: Step out of method
   - `<leader>dc`: Continue to next breakpoint

6. **Hot code replace** (if needed):
   - Edit the code while paused
   - Save the file
   - jdtls reloads the method
   - Continue debugging with new code

7. **Terminate**:
   - `<leader>dt`: Stop debugging
   - `<leader>dx`: Stop and close DAP UI

### Workflow 3: Running Tests with Coverage

**Goal**: Run tests and view coverage report

**Steps:**

1. **Install coverage tools**:
   ```bash
   # Maven
   # Add jacoco plugin to pom.xml

   # Gradle
   # Add jacoco plugin to build.gradle
   ```

2. **Run tests with coverage** (Maven):
   ```vim
   :!mvn clean test jacoco:report
   ```

3. **View coverage report**:
   ```bash
   # Maven: target/site/jacoco/index.html
   # Gradle: build/reports/jacoco/test/html/index.html
   open target/site/jacoco/index.html
   ```

4. **Optional**: Integrate with neotest for inline coverage:
   - Use `neotest-java` adapter
   - Run tests: `:lua require("neotest").run.run()`
   - View results in test summary panel

### Workflow 4: Format All Java Files

**Goal**: Apply google-java-format to entire project

**Steps:**

1. **Single file** (current buffer):
   ```vim
   :Format  " With conform.nvim
   " Or
   :lua vim.lsp.buf.format()
   ```

2. **All files in project** (command-line):
   ```bash
   # Via google-java-format CLI
   find src -name "*.java" -exec google-java-format --aosp -i {} \;

   # Or via Maven plugin (add to pom.xml first)
   mvn com.spotify.fmt:fmt-maven-plugin:format
   ```

3. **Format on save** (automatic):
   ```lua
   -- With conform.nvim
   opts = {
     format_on_save = {
       timeout_ms = 500,
       lsp_fallback = true,
     },
   }
   ```

### Workflow 5: Quick Java File Compilation (No LSP)

**Goal**: Compile and run a single Java file without LSP (works with Java 24)

**Current approach in your config:**

```lua
-- In lua/plugins/development-algorithm.lua
-- Test runner for Java (uses local javac compiler)
vim.keymap.set("n", "<leader>Dtr", function()
  local file = vim.fn.expand("%:p")
  if vim.bo.filetype == "java" then
    vim.cmd("!javac " .. file .. " && java " .. vim.fn.expand("%:t:r"))
  end
end, { desc = "Run Java file" })
```

**Enhanced version with error handling:**

```lua
-- Compile current Java file
vim.keymap.set("n", "<leader>Jc", function()
  local file = vim.fn.expand("%:p")
  local class_name = vim.fn.expand("%:t:r")

  -- Compile
  local compile_result = vim.fn.system("javac " .. file)
  if vim.v.shell_error == 0 then
    vim.notify("Compiled successfully: " .. class_name, vim.log.levels.INFO)
  else
    vim.notify("Compilation failed:\n" .. compile_result, vim.log.levels.ERROR)
  end
end, { desc = "Compile Java file" })

-- Run compiled Java class
vim.keymap.set("n", "<leader>Jr", function()
  local class_name = vim.fn.expand("%:t:r")
  vim.cmd("!java " .. class_name)
end, { desc = "Run Java class" })

-- Compile and run in one step
vim.keymap.set("n", "<leader>JJ", function()
  local file = vim.fn.expand("%:p")
  local class_name = vim.fn.expand("%:t:r")

  -- Compile
  local compile_result = vim.fn.system("javac " .. file)
  if vim.v.shell_error == 0 then
    -- Run
    vim.cmd("!java " .. class_name)
  else
    vim.notify("Compilation failed:\n" .. compile_result, vim.log.levels.ERROR)
  end
end, { desc = "Compile and Run Java file" })
```

---

## Summary and Recommendations

### For Your Current Setup (Java 24)

**Option 1: Use Treesitter Only (Current State)**
- ✅ Syntax highlighting works perfectly
- ✅ Code navigation via Treesitter
- ✅ Simple compile-and-run workflows
- ❌ No LSP features (autocomplete, go-to-definition, etc.)
- ❌ No debugging support
- ❌ No refactoring tools

**Option 2: Install Java 21 (Recommended)**
- ✅ Full LSP support via jdtls
- ✅ Debugging with nvim-dap
- ✅ Test integration with neotest-java
- ✅ Refactoring and code actions
- ✅ Can still compile Java 24 projects
- Configure jdtls to use Java 21 runtime but Java 24 for projects

### Minimal Working Configuration

If you install Java 21, here's a minimal config to add:

```lua
-- In lua/plugins/lsp.lua
-- Uncomment jdtls:
jdtls = {
  settings = {
    java = {
      home = "/path/to/java-21",  -- Point to Java 21
      configuration = {
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/path/to/java-21",
            default = true,
          },
          {
            name = "JavaSE-24",
            path = "/path/to/java-24",
          },
        },
      },
    },
  },
},

-- In lua/plugins/dap.lua
-- Uncomment nvim-java or configure java-debug manually

-- Install via Mason:
-- :MasonInstall jdtls java-debug-adapter java-test google-java-format
```

### Key Takeaways

1. **jdtls requires Java 21** to run but supports Java 24 projects
2. **nvim-java vs nvim-jdtls**: Choose one, not both
   - nvim-java: Easier setup, "batteries included"
   - nvim-jdtls: More control, manual configuration
3. **Treesitter works with Java 24** - use it for syntax highlighting
4. **Testing**: neotest-java provides the best Neovim integration for JUnit
5. **Formatting**: google-java-format via conform.nvim or none-ls
6. **Build tools**: Maven and Gradle work seamlessly with jdtls

---

## Additional Resources

### Official Documentation
- jdtls: https://github.com/eclipse-jdtls/eclipse.jdt.ls
- nvim-java: https://github.com/nvim-java/nvim-java
- nvim-jdtls: https://github.com/mfussenegger/nvim-jdtls
- nvim-dap: https://github.com/mfussenegger/nvim-dap
- neotest: https://github.com/nvim-neotest/neotest
- neotest-java: https://github.com/rcasia/neotest-java

### Community Resources
- LazyVim Java Setup: https://www.lorenzobettini.it/2024/11/neovim-and-java-with-lazyvim-part-1-initial-configuration/
- Neovim as Java IDE: https://sookocheff.com/post/vim/neovim-java-ide/
- nvim-dap Java Wiki: https://github.com/mfussenegger/nvim-dap/wiki/Java

### Troubleshooting

**Problem**: "jdtls not found"
- **Solution**: Install via Mason: `:MasonInstall jdtls`

**Problem**: "Could not find or load main class"
- **Solution**: Check `root_dir` in jdtls config points to project root

**Problem**: "Unsupported Java version"
- **Solution**: Set JAVA_HOME to Java 21 before starting Neovim

**Problem**: Debugging doesn't work
- **Solution**: Ensure java-debug-adapter bundles are loaded in init_options

**Problem**: Tests not discovered
- **Solution**: Install Treesitter Java parser: `:TSInstall java`

**Problem**: Format on save too slow
- **Solution**: Increase timeout in conform.nvim: `timeout_ms = 1000`

---

**Generated**: 2025-01-08
**For Neovim Config**: `/Users/brunodossantos/.config/nvim`
**Current Java Version**: Java 24 (jdtls disabled)
**Recommended Action**: Install Java 21 to enable full LSP features
