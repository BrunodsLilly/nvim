# Modern Java Development Best Practices for Neovim in 2025

**Research Date:** November 8, 2025
**Target Environment:** Neovim + Java 24 + Modern Tooling
**Status:** Current configuration uses Treesitter only (jdtls disabled due to Java 24 incompatibility)

---

## Executive Summary

This research provides comprehensive guidance for modern Java development in Neovim for 2025, addressing the specific challenge of working with Java 24 (which jdtls doesn't yet support) while maintaining professional IDE-like capabilities. The document covers LSP alternatives, testing frameworks, debugging solutions, build tool integration, and code quality tooling.

**Key Finding:** jdtls DOES support Java 24 as of version 1.46.0 (released March 27, 2025), but requires Java 21 runtime to operate. This means you can use jdtls with Java 24 projects by installing both JDK versions.

---

## 1. Java LSP Solutions for Java 24

### 1.1 jdtls with Multiple JDK Versions (RECOMMENDED)

**Official Status:**
- jdtls **DOES support Java 24** compilation (as of version 1.46.0, March 2025)
- Requires **Java 21+ runtime** to run the language server itself
- Supports compiling projects from Java 1.8 through 24

**Solution: Use Java 21 for jdtls, Java 24 for Projects**

```lua
-- Configuration in after/ftplugin/java.lua or via nvim-jdtls
settings = {
  java = {
    configuration = {
      runtimes = {
        {
          name = "JavaSE-21",
          path = "/usr/lib/jvm/java-21-openjdk/",
          default = true  -- This runs jdtls
        },
        {
          name = "JavaSE-24",
          path = "/usr/lib/jvm/java-24-openjdk/"  -- Projects can use this
        },
        {
          name = "JavaSE-17",
          path = "/usr/lib/jvm/java-17-openjdk/"  -- LTS fallback
        }
      }
    }
  }
}
```

**Installation Steps:**

1. Install both JDK 21 (for jdtls) and JDK 24 (for your projects):
   ```bash
   # macOS with Homebrew
   brew install openjdk@21
   brew install openjdk@24

   # Ubuntu/Debian
   sudo apt install openjdk-21-jdk openjdk-24-jdk
   ```

2. Set JAVA_HOME to JDK 21 (for jdtls to run):
   ```bash
   export JAVA_HOME=/usr/local/opt/openjdk@21
   export PATH="$JAVA_HOME/bin:$PATH"
   ```

3. Configure jdtls runtimes (see above) to use Java 24 for projects

4. Your pom.xml or build.gradle can specify Java 24 as the target version

**Why This Works:**
- jdtls is a Java application that runs on the JVM (needs Java 21+)
- Once running, jdtls can compile and analyze Java code for ANY version (8-24)
- The language server uses the configured runtime for each project

### 1.2 Plugin Choice: nvim-jdtls vs nvim-java

**Critical Decision:** You CANNOT use both plugins simultaneously. Choose ONE approach.

#### nvim-jdtls (KISS Principle - Recommended for Experienced Users)

**Philosophy:**
- "Keep it simple, stupid!" approach
- Configuration as code over GUI
- Maximum control and customization
- Targets experienced Neovim users
- Ease of use is NOT the priority

**Pros:**
- Fine-grained control over every aspect
- Minimal abstraction over eclipse.jdt.ls
- Consistent with Neovim's LSP architecture
- Uses same keybindings/patterns as other language servers
- Well-documented and stable
- Smaller codebase, easier to debug

**Cons:**
- More manual configuration required
- Steeper learning curve
- Need to understand jdtls concepts
- Manual setup for java-debug and java-test extensions

**Installation (Lazy.nvim):**

```lua
{
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-dap",  -- Debugging support
  }
}
```

**Configuration Pattern:**
- Create `~/.config/nvim/after/ftplugin/java.lua` (auto-loaded for Java files)
- Configure jdtls with all initialization options
- Manually specify paths to java-debug and java-test JARs
- See "Setup Example" section below

#### nvim-java (Batteries-Included - Recommended for Beginners)

**Philosophy:**
- Opinionated, automated setup
- "Painless Java in Neovim"
- GUI-like experience
- Minimal configuration needed
- Ease of use IS the priority

**Pros:**
- Automatic installation of dependencies (java-test, java-debug)
- Pre-configured keybindings and workflows
- Spring Boot tools integration
- Easier for Java IDE migrants
- Active development in 2025

**Cons:**
- Less customization flexibility
- Abstraction layer over jdtls
- Plugin-specific keybindings to learn
- Potential conflicts with custom LSP setups
- Heavier dependency footprint

**Installation (Lazy.nvim + LazyVim):**

```lua
{
  "nvim-java/nvim-java",
  ft = "java",
  dependencies = {
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "nvim-java/nvim-java-refactor",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
  opts = {
    -- nvim-java auto-configures jdtls for you
    spring_boot_tools = {
      enable = true,  -- Spring Boot support
    },
  },
}
```

**How It Works:**
- Loads java-test & java-debug extensions automatically
- Communicates with jdtls on your behalf
- Provides higher-level APIs for testing and debugging

**Recommendation for Your Setup:**
Given your existing configuration philosophy (manual control, KISS principle, configuration as code), **nvim-jdtls** aligns better with your development algorithm and customization preferences.

### 1.3 LSP Alternatives (If You Don't Want jdtls)

**Reality Check:** There are NO viable alternatives to jdtls for Java LSP in 2025.

- **google-java-language-server**: Abandoned since 2019
- **java-language-server** (George Fraser): Unmaintained
- **jdt.ls** IS the de facto standard for all editors (VS Code, Neovim, Emacs, Zed, Helix)

**Fallback Options:**
1. **No LSP, Treesitter only** (your current setup):
   - Syntax highlighting via Treesitter ✓
   - No completion, go-to-definition, refactoring ✗
   - Works with Java 24 ✓
   - Recommended only as temporary solution

2. **Use VSCode with vscode-neovim**:
   - Embed real Neovim instance in VSCode
   - Get full Java support from VSCode's extension
   - Keep Neovim keybindings and workflow
   - Trade-off: Not pure Neovim

---

## 2. Testing Frameworks and Automation

### 2.1 JUnit 5 Integration in Neovim

**Primary Tool:** nvim-jdtls provides built-in JUnit testing via java-test extension

**Required Setup:**

1. **Install java-test extension** (vscode-java-test):
   ```bash
   # Download from https://github.com/microsoft/vscode-java-test/releases
   # Extract JAR files to ~/.local/share/nvim/java-test/
   ```

2. **Configure jdtls to load java-test bundles:**
   ```lua
   local bundles = {}

   -- Add java-debug JARs
   vim.list_extend(bundles, vim.split(
     vim.fn.glob("~/.local/share/nvim/java-debug/com.microsoft.java.debug.plugin/target/*.jar"),
     "\n"
   ))

   -- Add java-test JARs
   vim.list_extend(bundles, vim.split(
     vim.fn.glob("~/.local/share/nvim/java-test/server/*.jar"),
     "\n"
   ))

   config.init_options = {
     bundles = bundles
   }
   ```

3. **Testing Functions:**
   ```lua
   local jdtls = require('jdtls')

   -- Test entire class
   vim.keymap.set('n', '<leader>tc', jdtls.test_class, { desc = "Test Class" })

   -- Test method under cursor
   vim.keymap.set('n', '<leader>tm', jdtls.test_nearest_method, { desc = "Test Method" })
   ```

**How It Works:**
- jdtls discovers JUnit tests in your project
- Automatically registers debug configurations
- Integrates with nvim-dap for debugging tests
- Supports JUnit 4, JUnit 5, and TestNG

**Test Discovery:**
- Scans classpath for `@Test` annotations
- Detects test classes (suffix: `Test`, `Tests`, `TestCase`)
- Identifies test methods via annotations

### 2.2 Maven/Gradle Test Runners

**Option 1: Direct Build Tool Execution (Simplest)**

Your current approach in `development-algorithm.lua`:

```lua
-- Maven test runner
{
  "<leader>Dtr",
  function()
    vim.cmd("!mvn test -Dtest=" .. vim.fn.expand("%:t:r"))
  end,
  desc = "Run test for current file"
}

-- Gradle test runner
{
  "<leader>Dtr",
  function()
    local class_name = vim.fn.expand("%:t:r")
    vim.cmd("!./gradlew test --tests " .. class_name)
  end,
  desc = "Run test for current file"
}
```

**Option 2: Overseer.nvim Integration (Recommended for Complex Projects)**

Overseer provides task management with output parsing:

```lua
-- Install
{ "stevearc/overseer.nvim", opts = {} }

-- Add custom Maven task template
-- In ~/.config/nvim/lua/overseer/template/user/maven_test.lua
return {
  name = "Maven Test",
  builder = function()
    local file = vim.fn.expand("%:p")
    local class_name = vim.fn.expand("%:t:r")

    return {
      cmd = { "mvn" },
      args = {
        "test",
        "-Dtest=" .. class_name,
      },
      components = {
        { "on_output_quickfix", open = true },
        "on_result_diagnostics",
        "on_exit_set_status",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "java" },
  },
}
```

**Usage:**
```lua
-- Run via overseer
:OverseerRun maven_test

-- Keybinding
vim.keymap.set('n', '<leader>Dtr', '<cmd>OverseerRun maven_test<cr>')
```

**Option 3: Compiler.nvim (Build Automation)**

```lua
{
  "Zeioth/compiler.nvim",
  dependencies = { "stevearc/overseer.nvim" },
  opts = {},
}
```

- Supports Maven, Gradle, Ant
- Can add custom build tools
- Relies on overseer.nvim for task execution

**Option 4: vim-test Plugin (Multi-Language Testing)**

```lua
{
  "vim-test/vim-test",
  keys = {
    { "<leader>tt", "<cmd>TestNearest<cr>", desc = "Test Nearest" },
    { "<leader>tf", "<cmd>TestFile<cr>", desc = "Test File" },
    { "<leader>ta", "<cmd>TestSuite<cr>", desc = "Test Suite" },
    { "<leader>tl", "<cmd>TestLast<cr>", desc = "Test Last" },
  },
}
```

**Supports:**
- Maven: `maventest` runner
- Gradle: `gradletest` runner (with `./gradlew` support)

**Configuration:**
```vim
let test#java#runner = 'maventest'
" or
let test#java#runner = 'gradletest'
let test#java#gradletest#executable = './gradlew'
```

**Option 5: Neotest Framework (Modern Testing UI)**

```lua
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-vim-test",  -- Fallback adapter
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vim-test")({
          allow_file_types = { "java" },
        }),
      },
    })
  end,
}
```

**Features:**
- Interactive test UI
- Per-test output
- Test status indicators
- Can use vim-test as backend

**Note:** No native neotest-java adapter exists (as of 2025), but vim-test adapter works.

**Recommendation:**
- **Simple projects:** Direct Maven/Gradle commands
- **Complex projects:** Overseer.nvim for task management
- **Multi-language:** vim-test for consistency
- **IDE-like UI:** Neotest + vim-test adapter

### 2.3 Watch Mode for Java Tests

**Challenge:** Java doesn't have native watch mode like pytest `--watch`

**Solutions:**

#### Option 1: Code Runner with Hot Reload (Experimental)

```lua
{
  "CRAG666/code_runner.nvim",
  config = function()
    require("code_runner").setup({
      hot_reload = true,  -- Experimental feature
      filetype = {
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt"
        },
      },
    })
  end,
}
```

**How It Works:**
- Watches file for changes
- Recompiles and runs on save
- Shows output in floating window

**Limitations:**
- Experimental
- Not full test runner
- Better for single-file programs

#### Option 2: Autocommand-Based Watch (DIY)

```lua
-- In your config
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.java",
  callback = function()
    vim.cmd("!mvn test -Dtest=" .. vim.fn.expand("%:t:r"))
  end,
})
```

**Pros:**
- Simple, built-in
- No dependencies

**Cons:**
- Runs on EVERY save (can be slow)
- No test result caching

#### Option 3: Spring Boot DevTools (For Spring Projects)

**Installation:**

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```

**Neovim Integration:**

```lua
{
  "elmcgill/springboot-nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-jdtls",
  },
  ft = "java",
  config = function()
    require("springboot-nvim").setup()
  end,
}
```

**Features:**
- Incremental compilation on save
- Auto-restart Spring Boot app
- Hot reload support
- Requires classpath updates to trigger restart

**How It Works:**
1. springboot-nvim triggers compilation on save
2. DevTools detects classpath changes
3. App automatically restarts with new code

**Best Practice:**
- Use Spring Boot DevTools for application hot reload
- Use standard test runners (Maven/Gradle) for unit tests
- Combine with overseer.nvim for task automation

#### Option 4: Gradle Continuous Build

```bash
# Run in terminal split
./gradlew test --continuous

# Or via Neovim terminal
:terminal ./gradlew test --continuous
```

**How It Works:**
- Gradle watches for file changes
- Automatically re-runs tests
- Native Gradle feature

**Neovim Integration:**

```lua
-- Add to keybindings
vim.keymap.set('n', '<leader>Dtw', function()
  vim.cmd("vsplit | terminal ./gradlew test --continuous")
end, { desc = "Watch Tests (Gradle Continuous)" })
```

**Recommendation:**
- **Spring Boot apps:** Use springboot-nvim + DevTools
- **Gradle projects:** Use `--continuous` flag
- **Maven projects:** DIY autocommand or manual re-runs
- **General:** code_runner.nvim for experimental hot reload

### 2.4 Test Coverage Tools

#### JaCoCo Integration

**Setup in Maven:**

```xml
<!-- pom.xml -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.11</version>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

**Generate Coverage:**

```bash
mvn clean test
# Generates: target/site/jacoco/jacoco.xml
```

**Neovim Coverage Plugins:**

**Option 1: blanket.nvim (JaCoCo-Specific)**

```lua
{
  "dsych/blanket.nvim",
  config = function()
    require("blanket").setup({
      report_path = vim.fn.getcwd() .. "/target/site/jacoco/jacoco.xml",
      -- Gutter indicators
      signs = {
        uncovered = "█",
        covered = "█",
        partial = "█",
      },
      -- Sign colors
      highlights = {
        uncovered = { fg = "#f38ba8" },  -- Red
        covered = { fg = "#a6e3a1" },    -- Green
        partial = { fg = "#f9e2af" },    -- Yellow
      },
    })
  end,
  keys = {
    { "<leader>cb", "<cmd>BlanketRefresh<cr>", desc = "Refresh Coverage" },
    { "<leader>cs", "<cmd>BlanketToggle<cr>", desc = "Toggle Coverage" },
  },
}
```

**Features:**
- Real-time coverage gutter
- Watches JaCoCo XML for changes
- Shows covered/uncovered/partial lines
- Supports inline coverage metrics

**Option 2: nvim-coverage (Multi-Format)**

```lua
{
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("coverage").setup({
      auto_reload = true,
      lang = {
        java = {
          coverage_file = vim.fn.getcwd() .. "/target/site/jacoco/jacoco.xml",
        },
      },
    })
  end,
  keys = {
    { "<leader>cc", "<cmd>Coverage<cr>", desc = "Show Coverage" },
    { "<leader>ct", "<cmd>CoverageToggle<cr>", desc = "Toggle Coverage" },
    { "<leader>cs", "<cmd>CoverageSummary<cr>", desc = "Coverage Summary" },
  },
}
```

**Features:**
- Supports multiple formats (Cobertura, JaCoCo via conversion)
- Sign column indicators
- Summary floating window
- Line-level coverage data

**JaCoCo to Cobertura Conversion (if needed):**

```bash
# Install converter
pip install cover2cover

# Convert
cover2cover target/site/jacoco/jacoco.xml > coverage.xml
```

**Integration with Your Workflow:**

```lua
-- Add to development-algorithm.lua keybindings
{
  "<leader>Dtc",
  function()
    -- Run tests with coverage
    vim.cmd("!mvn clean test")

    -- Refresh coverage display
    vim.cmd("BlanketRefresh")  -- or "Coverage"
  end,
  desc = "Run tests with coverage"
}
```

**Recommendation:**
- **JaCoCo projects:** Use blanket.nvim (native support)
- **Multiple formats:** Use nvim-coverage (flexible)
- **Best practice:** Integrate with test keybindings for automatic refresh

---

## 3. Debugging Solutions

### 3.1 nvim-dap with Java Debug Server

**Architecture:**
- nvim-dap (Neovim DAP client)
- java-debug-adapter (Microsoft's VS Code Java debugger)
- jdtls (coordinates debugging session)

**Installation:**

1. **Install java-debug extension:**

```bash
# Clone and build
git clone https://github.com/microsoft/java-debug.git
cd java-debug
./mvnw clean install

# JARs will be in: com.microsoft.java.debug.plugin/target/
```

2. **Install nvim-dap:**

```lua
{
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",      -- UI for DAP
    "nvim-neotest/nvim-nio",      -- Async I/O
    "theHamsta/nvim-dap-virtual-text",  -- Inline variable values
  },
}
```

3. **Configure jdtls to load java-debug:**

```lua
-- In after/ftplugin/java.lua
local bundles = {
  vim.fn.glob(
    "~/.local/share/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
    1
  )
}

config.init_options = {
  bundles = bundles
}
```

4. **Setup nvim-dap for Java:**

```lua
-- jdtls automatically registers Java adapter with nvim-dap
-- No manual adapter configuration needed!

-- Add keybindings
local dap = require('dap')

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = "Continue" })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = "Step Into" })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = "Step Over" })
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = "Step Out" })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = "Terminate" })
vim.keymap.set('n', '<leader>du', function()
  require('dapui').toggle()
end, { desc = "Toggle DAP UI" })
```

**Debug Configurations:**

jdtls auto-discovers main classes and creates configurations:

```lua
-- Manually add custom configuration (optional)
local dap = require('dap')

table.insert(dap.configurations.java, {
  type = 'java',
  request = 'launch',
  name = "Launch Main",
  mainClass = "com.example.Main",
  projectName = "my-project",
  args = "",
})

-- Remote debugging
table.insert(dap.configurations.java, {
  type = 'java',
  request = 'attach',
  name = "Attach to Remote",
  hostName = "127.0.0.1",
  port = 5005,
})
```

**VS Code launch.json Support:**

jdtls reads `.vscode/launch.json` in project root:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "Launch App",
      "request": "launch",
      "mainClass": "com.example.App",
      "projectName": "my-project",
      "args": "--config prod"
    }
  ]
}
```

### 3.2 Alternative Debugging Without jdtls

**Reality:** There are NO viable alternatives for Java debugging in Neovim without jdtls.

**Why:**
- java-debug-adapter requires jdtls to coordinate
- jdtls provides classpath discovery
- jdtls discovers main classes and tests
- All modern editors use the same stack

**Options if jdtls unavailable:**

1. **Command-line debugging (jdb):**
   ```bash
   # Compile with debug info
   javac -g MyProgram.java

   # Run with debug agent
   java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005 MyProgram

   # Attach jdb
   jdb -attach 5005
   ```

2. **Terminal-based debuggers:**
   - jdb (built-in)
   - GDB with Java support
   - Not practical for modern development

**Recommendation:** Install Java 21 to run jdtls, use Java 24 for projects (see Section 1.1)

### 3.3 Java Debugger Configuration Best Practices

**DAP UI Setup:**

```lua
require("dapui").setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 0.33,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.45 },
        { id = "console", size = 0.55 },
      },
      size = 0.27,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
  },
  floating = {
    border = "rounded",
  },
})
```

**Virtual Text (Inline Variables):**

```lua
require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = '<module',
  virt_text_pos = 'eol',
})
```

**Custom Signs:**

```lua
vim.fn.sign_define("DapBreakpoint", {
  text = "🔴",
  texthl = "DiagnosticError"
})
vim.fn.sign_define("DapStopped", {
  text = "▶️",
  texthl = "DiagnosticInfo"
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = "🟡",
  texthl = "DiagnosticWarn"
})
vim.fn.sign_define("DapLogPoint", {
  text = "📝",
  texthl = "DiagnosticInfo"
})
```

**Auto-open/close DAP UI:**

```lua
local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
```

**Persistent Breakpoints:**

```lua
-- Save breakpoints to file
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local dap = require("dap")
    local breakpoints = {}

    for buf, buf_bps in pairs(dap.breakpoints.get()) do
      local file = vim.api.nvim_buf_get_name(buf)
      if file ~= "" then
        breakpoints[file] = buf_bps
      end
    end

    local file = io.open(vim.fn.stdpath("data") .. "/dap-breakpoints.json", "w")
    if file then
      file:write(vim.json.encode(breakpoints))
      file:close()
    end
  end,
})

-- Restore breakpoints on startup
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local file = io.open(vim.fn.stdpath("data") .. "/dap-breakpoints.json", "r")
    if not file then return end

    local content = file:read("*a")
    file:close()

    local breakpoints = vim.json.decode(content)
    if not breakpoints then return end

    local dap = require("dap")
    for file_path, file_bps in pairs(breakpoints) do
      for _, bp in ipairs(file_bps) do
        dap.set_breakpoint(bp.line, bp.condition, bp.logMessage)
      end
    end
  end,
})
```

**JUnit Test Debugging:**

```lua
-- Debug test under cursor
vim.keymap.set('n', '<leader>dt', function()
  require('jdtls').test_nearest_method()
end, { desc = "Debug Test Method" })

-- Debug entire test class
vim.keymap.set('n', '<leader>dT', function()
  require('jdtls').test_class()
end, { desc = "Debug Test Class" })
```

---

## 4. Build Tool Integration

### 4.1 Maven Wrapper (mvnw) in Neovim

**Detection and Usage:**

```lua
-- Auto-detect Maven wrapper
local function get_maven_cmd()
  if vim.fn.filereadable("mvnw") == 1 then
    return "./mvnw"
  elseif vim.fn.filereadable("mvnw.cmd") == 1 then
    return "mvnw.cmd"  -- Windows
  else
    return "mvn"  -- Fallback to system Maven
  end
end

-- Use in commands
vim.keymap.set('n', '<leader>mc', function()
  local maven = get_maven_cmd()
  vim.cmd("!" .. maven .. " clean compile")
end, { desc = "Maven Compile" })

vim.keymap.set('n', '<leader>mt', function()
  local maven = get_maven_cmd()
  vim.cmd("!" .. maven .. " test")
end, { desc = "Maven Test" })
```

**Maven.nvim Plugin:**

```lua
{
  "eatgrass/maven.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("maven").setup({
      executable = "./mvnw",  -- Auto-detects wrapper
    })
  end,
  keys = {
    { "<leader>mc", "<cmd>Maven clean compile<cr>", desc = "Maven Clean Compile" },
    { "<leader>mt", "<cmd>Maven test<cr>", desc = "Maven Test" },
    { "<leader>mp", "<cmd>Maven package<cr>", desc = "Maven Package" },
    { "<leader>mi", "<cmd>Maven clean install<cr>", desc = "Maven Install" },
  },
}
```

**Features:**
- Interactive Maven command execution
- Wrapper auto-detection
- Output in floating window
- Command history

**jdtls Maven Integration:**

jdtls automatically detects pom.xml and configures classpath:

```lua
-- In jdtls config
settings = {
  java = {
    maven = {
      downloadSources = true,
      updateSnapshots = false,
    },
    configuration = {
      updateBuildConfiguration = "automatic",  -- or "interactive"
    },
  },
}
```

**Update Build Configuration Options:**
- `disabled`: Never update classpath
- `interactive`: Prompt before updating
- `automatic`: Auto-update on pom.xml changes

### 4.2 Gradle Integration Patterns

**Gradle Wrapper Detection:**

```lua
local function get_gradle_cmd()
  if vim.fn.filereadable("gradlew") == 1 then
    return "./gradlew"
  elseif vim.fn.filereadable("gradlew.bat") == 1 then
    return "gradlew.bat"  -- Windows
  else
    return "gradle"  -- Fallback to system Gradle
  end
end

-- Use in commands
vim.keymap.set('n', '<leader>gb', function()
  local gradle = get_gradle_cmd()
  vim.cmd("!" .. gradle .. " build")
end, { desc = "Gradle Build" })

vim.keymap.set('n', '<leader>gt', function()
  local gradle = get_gradle_cmd()
  vim.cmd("!" .. gradle .. " test")
end, { desc = "Gradle Test" })
```

**jdtls Gradle Integration:**

```lua
settings = {
  java = {
    gradle = {
      wrapper = {
        enabled = true,  -- Use wrapper if available
      },
      offline = false,
    },
  },
}
```

**Gradle Task Runner (via Telescope):**

```lua
-- Custom Telescope picker for Gradle tasks
local function gradle_tasks()
  local gradle = get_gradle_cmd()
  local tasks = vim.fn.systemlist(gradle .. " tasks --all")

  require("telescope.pickers").new({}, {
    prompt_title = "Gradle Tasks",
    finder = require("telescope.finders").new_table({
      results = tasks,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        local task = selection[1]:match("^(%S+)")
        vim.cmd("!" .. gradle .. " " .. task)
      end)
      return true
    end,
  }):find()
end

vim.keymap.set('n', '<leader>gT', gradle_tasks, { desc = "Gradle Tasks" })
```

### 4.3 Build Automation with Overseer.nvim

**Installation:**

```lua
{
  "stevearc/overseer.nvim",
  opts = {
    strategy = {
      "toggleterm",
      direction = "horizontal",
      autos_croll = true,
      quit_on_exit = "success"
    },
    templates = { "builtin", "user" },
  },
  keys = {
    { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Task Info" },
  },
}
```

**Custom Maven Task Template:**

Create `~/.config/nvim/lua/overseer/template/user/maven.lua`:

```lua
return {
  name = "Maven Build",
  builder = function()
    return {
      cmd = { "./mvnw" },
      args = { "clean", "install", "-DskipTests" },
      components = {
        { "on_output_quickfix", open = true },
        "on_result_diagnostics",
        "on_exit_set_status",
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      return vim.fn.filereadable("pom.xml") == 1
    end,
  },
  tags = { "build", "maven" },
}
```

**Custom Gradle Task Template:**

Create `~/.config/nvim/lua/overseer/template/user/gradle.lua`:

```lua
return {
  name = "Gradle Build",
  builder = function()
    return {
      cmd = { "./gradlew" },
      args = { "build" },
      components = {
        { "on_output_quickfix", open = true },
        "on_result_diagnostics",
        "on_exit_set_status",
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      return vim.fn.filereadable("build.gradle") == 1
        or vim.fn.filereadable("build.gradle.kts") == 1
    end,
  },
  tags = { "build", "gradle" },
}
```

**Features:**
- Task output parsing
- Quickfix integration
- Task history and re-run
- Multiple concurrent tasks
- Status indicators

**Integration with Your Workflow:**

```lua
-- Add to development-algorithm.lua
{
  "<leader>Db",
  "<cmd>OverseerRun<cr>",
  desc = "Build project (Overseer)"
}
```

---

## 5. Code Quality and Linting

### 5.1 Checkstyle Integration

**Installation:**

```bash
# Download Checkstyle JAR
curl -L https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.5/checkstyle-10.12.5-all.jar \
  -o ~/.local/share/checkstyle.jar
```

**none-ls (formerly null-ls) Configuration:**

```lua
{
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Checkstyle diagnostics
        null_ls.builtins.diagnostics.checkstyle.with({
          command = "java",
          args = {
            "-jar",
            vim.fn.expand("~/.local/share/checkstyle.jar"),
            "-c",
            "/google_checks.xml",  -- or /sun_checks.xml, or custom path
            "$FILENAME",
          },
          extra_args = { "-f", "xml" },
        }),
      },
    })
  end,
}
```

**Custom Checkstyle Configuration:**

```xml
<!-- checkstyle.xml in project root -->
<?xml version="1.0"?>
<!DOCTYPE module PUBLIC
  "-//Checkstyle//DTD Checkstyle Configuration 1.3//EN"
  "https://checkstyle.org/dtds/configuration_1_3.dtd">
<module name="Checker">
  <module name="TreeWalker">
    <module name="UnusedImports"/>
    <module name="RedundantImport"/>
    <module name="AvoidStarImport"/>
    <module name="LineLength">
      <property name="max" value="120"/>
    </module>
  </module>
</module>
```

**Use in none-ls:**

```lua
null_ls.builtins.diagnostics.checkstyle.with({
  extra_args = { "-c", vim.fn.getcwd() .. "/checkstyle.xml" },
})
```

**Maven Integration (Alternative):**

```xml
<!-- pom.xml -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-checkstyle-plugin</artifactId>
    <version>3.3.1</version>
    <configuration>
        <configLocation>checkstyle.xml</configLocation>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

### 5.2 SpotBugs or Error Prone

**Note:** none-ls does NOT have built-in SpotBugs support. Options:

#### Option 1: Maven Plugin (Run on Demand)

```xml
<!-- pom.xml -->
<plugin>
    <groupId>com.github.spotbugs</groupId>
    <artifactId>spotbugs-maven-plugin</artifactId>
    <version>4.8.2.0</version>
</plugin>
```

**Run:**

```bash
mvn spotbugs:check
```

**Keybinding:**

```lua
vim.keymap.set('n', '<leader>sb', function()
  vim.cmd("!mvn spotbugs:check")
end, { desc = "Run SpotBugs" })
```

#### Option 2: Error Prone (Compile-Time)

```xml
<!-- pom.xml -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.11.0</version>
    <configuration>
        <compilerArgs>
            <arg>-XDcompilePolicy=simple</arg>
            <arg>-Xplugin:ErrorProne</arg>
        </compilerArgs>
        <annotationProcessorPaths>
            <path>
                <groupId>com.google.errorprone</groupId>
                <artifactId>error_prone_core</artifactId>
                <version>2.24.1</version>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
```

**How It Works:**
- Error Prone runs during compilation
- Errors appear as compiler diagnostics
- jdtls shows them in Neovim automatically
- No additional plugin needed

**Recommendation:**
- Use Error Prone (compile-time, integrated with LSP)
- Use Checkstyle for style enforcement (via none-ls)
- Run SpotBugs manually or in CI/CD

### 5.3 Auto-Formatting with google-java-format

**Installation:**

```bash
# Download google-java-format JAR
curl -L https://github.com/google/google-java-format/releases/download/v1.19.2/google-java-format-1.19.2-all-deps.jar \
  -o ~/.local/share/google-java-format.jar
```

**Option 1: none-ls Integration (Recommended)**

```lua
{
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- google-java-format
        null_ls.builtins.formatting.google_java_format.with({
          command = "java",
          args = {
            "-jar",
            vim.fn.expand("~/.local/share/google-java-format.jar"),
            "-",
          },
        }),
      },
    })
  end,
}
```

**Option 2: conform.nvim (Modern Alternative)**

```lua
{
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
    },
    formatters = {
      ["google-java-format"] = {
        command = "java",
        args = {
          "-jar",
          vim.fn.expand("~/.local/share/google-java-format.jar"),
          "-",
        },
        stdin = true,
      },
    },
  },
}
```

**Format on Save:**

```lua
-- With conform.nvim
require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
```

**Manual Format Keybinding:**

```lua
vim.keymap.set('n', '<leader>cf', function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format Code" })
```

**jdtls Formatting (Alternative):**

jdtls has built-in Java formatter:

```lua
-- In jdtls settings
settings = {
  java = {
    format = {
      enabled = true,
      settings = {
        url = vim.fn.expand("~/.config/nvim/java-formatter.xml"),  -- Eclipse formatter config
        profile = "GoogleStyle",
      },
    },
  },
}
```

**Download Eclipse XML config:**

```bash
curl -L https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml \
  -o ~/.config/nvim/java-formatter.xml
```

**Recommendation:**
- **Simple setup:** Use jdtls built-in formatter
- **Multi-language consistency:** Use conform.nvim
- **Existing none-ls setup:** Add google-java-format to none-ls

---

## 6. Modern Java Development Patterns

### 6.1 Spring Boot Development Workflows

**Plugin: springboot-nvim**

```lua
{
  "elmcgill/springboot-nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-jdtls",
  },
  ft = "java",
  config = function()
    local springboot = require("springboot-nvim")

    springboot.setup({
      -- STS4 (Spring Tools 4) language server
      ls_path = vim.fn.stdpath("data") .. "/mason/packages/spring-boot-tools",
      jdtls_name = "jdtls",
      log_file = vim.fn.stdpath("data") .. "/springboot-nvim.log",
    })
  end,
  keys = {
    { "<leader>Jr", "<cmd>SpringBootRun<cr>", desc = "Spring Boot Run" },
    { "<leader>Jc", "<cmd>SpringBootStop<cr>", desc = "Spring Boot Stop" },
    { "<leader>Jd", "<cmd>SpringBootDebug<cr>", desc = "Spring Boot Debug" },
  },
}
```

**Spring Boot Tools LSP:**

Install via Mason:

```bash
:Mason
# Search: spring-boot-tools
# Press 'i' to install
```

**Features:**
- Spring Boot specific completions (application.properties, application.yml)
- Bean validation
- Request mapping navigation
- Incremental compilation for DevTools

**DevTools Configuration:**

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```

**How It Works:**
1. springboot-nvim triggers compilation on save (via jdtls)
2. DevTools detects classpath changes
3. Application auto-restarts with new code
4. Browser live-reloads (if configured)

**Live Reload Trigger:**

```lua
-- Auto-trigger save on buffer write
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.java",
  callback = function()
    -- jdtls auto-compiles, DevTools auto-reloads
    vim.notify("DevTools: Reloading...", vim.log.levels.INFO)
  end,
})
```

**REST Client Integration (Test APIs):**

```lua
{
  "mistweaverco/kulala.nvim",
  config = function()
    require("kulala").setup()
  end,
  keys = {
    { "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run Request" },
    { "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Run All Requests" },
  },
}
```

**Example .http file:**

```http
### Get all users
GET http://localhost:8080/api/users
Accept: application/json

### Create user
POST http://localhost:8080/api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
```

### 6.2 Microservices Debugging Patterns

**Remote Debugging Setup:**

1. **Start microservice with debug agent:**

```bash
# Service A on port 5005
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar service-a.jar

# Service B on port 5006
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5006 -jar service-b.jar
```

2. **Create debug configurations:**

```lua
-- In .vscode/launch.json or DAP config
local dap = require('dap')

table.insert(dap.configurations.java, {
  type = 'java',
  request = 'attach',
  name = "Attach: Service A (5005)",
  hostName = "127.0.0.1",
  port = 5005,
  projectName = "service-a",
})

table.insert(dap.configurations.java, {
  type = 'java',
  request = 'attach',
  name = "Attach: Service B (5006)",
  hostName = "127.0.0.1",
  port = 5006,
  projectName = "service-b",
})
```

3. **Switch between services:**

```lua
-- Telescope picker for debug configs
local function select_debug_config()
  local dap = require('dap')
  local configs = dap.configurations.java

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Debug Configurations",
    finder = finders.new_table({
      results = configs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        dap.run(selection.value)
      end)
      return true
    end,
  }):find()
end

vim.keymap.set('n', '<leader>ds', select_debug_config, { desc = "Select Debug Config" })
```

**Multiple Instance Debugging:**

```lua
-- Attach to multiple services simultaneously
vim.keymap.set('n', '<leader>dM', function()
  local dap = require('dap')

  -- Start session for Service A
  dap.run({
    type = 'java',
    request = 'attach',
    name = "Service A",
    hostName = "127.0.0.1",
    port = 5005,
  })

  -- Note: DAP supports ONE active session at a time
  -- To debug multiple, use separate Neovim instances or switch sessions

  vim.notify("Attached to Service A on port 5005", vim.log.levels.INFO)
  vim.notify("To attach Service B, run again with port 5006", vim.log.levels.INFO)
end, { desc = "Attach Microservices" })
```

**Docker Compose Integration:**

```yaml
# docker-compose.yml
version: '3.8'
services:
  service-a:
    build: ./service-a
    ports:
      - "8080:8080"
      - "5005:5005"  # Debug port
    environment:
      JAVA_TOOL_OPTIONS: "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"

  service-b:
    build: ./service-b
    ports:
      - "8081:8081"
      - "5006:5006"  # Debug port
    environment:
      JAVA_TOOL_OPTIONS: "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5006"
```

**Neovim Workflow:**

```lua
-- Start Docker Compose
vim.keymap.set('n', '<leader>Ju', function()
  vim.cmd("!docker-compose up -d")
end, { desc = "Docker Compose Up" })

-- Stop Docker Compose
vim.keymap.set('n', '<leader>Jd', function()
  vim.cmd("!docker-compose down")
end, { desc = "Docker Compose Down" })

-- Attach debugger to service
vim.keymap.set('n', '<leader>Ja', select_debug_config, { desc = "Attach to Service" })
```

### 6.3 Hot Reload/Restart Strategies

**Spring Boot DevTools (Automatic):**

See Section 6.1 for setup. Provides:
- Automatic restart on classpath changes
- Live reload for browser (with LiveReload extension)
- Remote debugging support
- Property defaults (e.g., disable template caching)

**JRebel (Commercial, Advanced):**

```lua
-- JRebel integration
vim.keymap.set('n', '<leader>Jj', function()
  vim.cmd("!mvn compile jrebel:generate")
end, { desc = "JRebel Generate" })
```

**Manual Restart Workflow:**

```lua
-- Kill and restart Spring Boot app
vim.keymap.set('n', '<leader>Jr', function()
  -- Kill existing process
  vim.cmd("!pkill -f 'java.*spring-boot'")

  vim.defer_fn(function()
    -- Start new process in background
    vim.cmd("!mvn spring-boot:run &")
    vim.notify("Spring Boot restarted", vim.log.levels.INFO)
  end, 500)
end, { desc = "Restart Spring Boot" })
```

**Recommendation:**
- **Development:** Spring Boot DevTools (free, integrated)
- **Complex changes:** JRebel (commercial, powerful)
- **Production-like:** Manual restart workflow

---

## 7. Neovim-Specific Java Plugins

### 7.1 nvim-java or Alternatives

**Ecosystem Overview:**

1. **nvim-java** (Opinionated Suite)
   - nvim-java-core: Core functionality
   - nvim-java-test: Testing integration
   - nvim-java-dap: Debugging integration
   - nvim-java-refactor: Refactoring tools

2. **nvim-jdtls** (KISS Plugin)
   - Minimal wrapper over eclipse.jdt.ls
   - Manual configuration
   - Direct LSP integration

3. **Supporting Plugins:**
   - springboot-nvim: Spring Boot specific
   - maven.nvim: Maven command runner
   - overseer.nvim: Build task automation

**Full nvim-java Setup:**

```lua
{
  "nvim-java/nvim-java",
  ft = "java",
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "nvim-java/nvim-java-refactor",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("java").setup({
      -- Root markers for project detection
      root_markers = {
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        ".git",
      },

      -- JDK configuration
      jdk = {
        auto_install = false,  -- Use system JDKs
      },

      -- Spring Boot tools
      spring_boot_tools = {
        enable = true,
      },

      -- Notifications
      notifications = {
        dap = true,
      },
    })
  end,
}

-- Then setup lspconfig as usual
require('lspconfig').jdtls.setup({})
```

**nvim-jdtls Setup (Minimal):**

```lua
-- Create after/ftplugin/java.lua
local jdtls = require('jdtls')

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob('~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/config_mac'),
    '-data', vim.fn.expand('~/.cache/jdtls/workspace/') .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  },

  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),

  settings = {
    java = {}
  },

  init_options = {
    bundles = {}
  },
}

jdtls.start_or_attach(config)
```

### 7.2 Treesitter Enhancements for Java

**Installation:**

```lua
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "java", "lua", "vim", "vimdoc" },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },

      -- Java-specific
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
      },
    })
  end,
}
```

**Java-Specific Text Objects:**

```lua
-- Add nvim-treesitter-textobjects
{
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
```

**Usage:**
- `vaf`: Select function (method) with annotations
- `vac`: Select class with modifiers
- `dif`: Delete function body
- `cic`: Change class body

**Treesitter Context (Show Current Method):**

```lua
{
  "nvim-treesitter/nvim-treesitter-context",
  opts = {
    enable = true,
    max_lines = 3,
  },
}
```

Shows current class/method at top of screen while scrolling.

### 7.3 Java-Specific Snippets and Completion

**LuaSnip + friendly-snippets:**

```lua
{
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Add custom Java snippets
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    ls.add_snippets("java", {
      s("psvm", {
        t("public static void main(String[] args) {"),
        t({"", "\t"}),
        i(0),
        t({"", "}"}),
      }),

      s("sout", {
        t("System.out.println("),
        i(1),
        t(");"),
      }),

      s("test", {
        t("@Test"),
        t({"", "public void "}),
        i(1, "testName"),
        t("() {"),
        t({"", "\t"}),
        i(0),
        t({"", "}"}),
      }),
    })
  end,
}
```

**Completion with blink.cmp (Your Setup):**

```lua
-- Already configured in your setup
-- blink.cmp automatically integrates with LSP and LuaSnip
```

**jdtls-Specific Completions:**

jdtls provides:
- Method signatures with parameter hints
- Import auto-completion
- Override method generation
- Generate getters/setters
- Constructor generation

**Trigger via Code Actions:**

```lua
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Actions" })
```

**Common Code Actions:**
- Organize imports
- Generate toString()
- Generate hashCode() and equals()
- Extract method/variable
- Inline variable

---

## 8. Comparison with VSCode Java Extension Features

### 8.1 Feature Parity Matrix

| Feature | VSCode Java Extension | Neovim (jdtls + plugins) | Status |
|---------|----------------------|--------------------------|--------|
| **Language Server** | eclipse.jdt.ls | eclipse.jdt.ls | ✅ Same |
| **Code Completion** | IntelliSense | LSP + blink.cmp | ✅ Equivalent |
| **Go to Definition** | Built-in | LSP | ✅ Equivalent |
| **Find References** | Built-in | LSP + Telescope | ✅ Better (fuzzy search) |
| **Refactoring** | GUI dialogs | Code actions | ✅ Equivalent |
| **Debugging** | GUI debugger | nvim-dap + dapui | ✅ Equivalent |
| **Test Runner** | Test Explorer | jdtls + neotest | ⚠️ Less visual |
| **Maven/Gradle** | GUI tasks | Terminal + keybindings | ⚠️ Less GUI |
| **Spring Boot** | Spring Initializr | Manual + springboot-nvim | ⚠️ Less integrated |
| **Dependency Management** | GUI tree | jdtls classpath | ✅ Equivalent |
| **Snippets** | Built-in | LuaSnip + friendly-snippets | ✅ Equivalent |
| **Auto-format** | Built-in | none-ls/conform.nvim | ✅ Equivalent |
| **Linting** | SonarLint, Checkstyle | none-ls + Checkstyle | ✅ Equivalent |
| **Project Creation** | GUI wizard | Manual or CLI | ❌ Missing |
| **Live Share** | Collaboration | ❌ Not available | ❌ Missing |

### 8.2 Advantages of Neovim

**1. Speed and Performance:**
- Faster startup (10-100x)
- Lower memory usage
- No Electron overhead
- Instant file navigation

**2. Keyboard-Centric Workflow:**
- No context switching to mouse
- Vim motions for code navigation
- Consistent keybindings across projects
- Faster text editing (ciw, dap, etc.)

**3. Customization:**
- Lua configuration (programmatic)
- Fine-grained control over LSP
- Custom workflows via keybindings
- Integration with shell/CLI tools

**4. Terminal Integration:**
- Native terminal buffers
- Run tests/builds without leaving editor
- Toggle terminal (ToggleTerm)
- Multiple terminal instances

**5. Lightweight:**
- Works over SSH
- Lower system resources
- Faster on older machines
- Remote development friendly

### 8.3 Advantages of VSCode

**1. Visual Features:**
- GUI debugger (drag-drop breakpoints)
- Test Explorer (tree view)
- Project creation wizards
- Spring Initializr integration

**2. Extensions Ecosystem:**
- SonarLint (real-time quality)
- GitLens (advanced Git visualization)
- Live Share (collaboration)
- Docker/Kubernetes integration

**3. Beginner-Friendly:**
- Point-and-click interface
- No configuration needed
- Discoverable features
- Better documentation (GUI tooltips)

**4. Team Compatibility:**
- Widely used (team familiarity)
- Standardized setup
- Easier onboarding
- Extension recommendations

### 8.4 Hybrid Approach: vscode-neovim

**Best of Both Worlds:**

Install `vscode-neovim` extension in VSCode:

```json
// settings.json
{
  "vscode-neovim.neovimExecutablePaths.darwin": "/usr/local/bin/nvim",
  "vscode-neovim.neovimInitVimPaths.darwin": "~/.config/nvim/init.lua",
}
```

**What You Get:**
- Real Neovim instance embedded in VSCode
- Full Vim motions and keybindings
- VSCode's Java extension features
- Your Neovim config and plugins
- VSCode's GUI when needed

**Trade-offs:**
- Heavier than pure Neovim
- Some Neovim plugins may conflict
- Not a "pure" Neovim experience

**Recommendation:**
- **Pure productivity:** Neovim (once configured)
- **Team environment:** VSCode with vscode-neovim
- **Learning:** Start with VSCode, migrate to Neovim

---

## 9. Recommended Setup for Your Configuration

### 9.1 Immediate Action Plan (Java 24 Support)

**Step 1: Install Java 21 (for jdtls)**

```bash
# macOS
brew install openjdk@21

# Set JAVA_HOME to Java 21
export JAVA_HOME=/usr/local/opt/openjdk@21
export PATH="$JAVA_HOME/bin:$PATH"

# Add to ~/.zshrc or ~/.bashrc to persist
```

**Step 2: Install jdtls via Mason**

```bash
# In Neovim
:Mason
# Search: jdtls
# Press 'i' to install
```

**Step 3: Configure Multiple JDK Runtimes**

Create `~/.config/nvim/after/ftplugin/java.lua`:

```lua
local jdtls = require('jdtls')

local config = {
  cmd = {
    'java',  -- Uses JAVA_HOME (should be Java 21)
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob('~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/config_mac'),
    '-data', vim.fn.expand('~/.cache/jdtls/workspace/') .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  },

  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),

  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/usr/local/opt/openjdk@21",
            default = true,
          },
          {
            name = "JavaSE-24",
            path = "/usr/local/opt/openjdk@24",  -- Your project JDK
          },
          {
            name = "JavaSE-17",
            path = "/usr/local/opt/openjdk@17",  -- LTS fallback
          },
        },
      },
    },
  },

  init_options = {
    bundles = {}
  },
}

jdtls.start_or_attach(config)
```

**Step 4: Enable jdtls in lsp.lua**

```lua
-- In lua/plugins/lsp.lua
server_configs = {
  -- ... other servers ...

  jdtls = {
    -- Handled by after/ftplugin/java.lua
    -- This entry tells mason to install it
  },
}
```

**Step 5: Update dap.lua for Java Debugging**

Uncomment the nvim-java plugin in `lua/plugins/dap.lua`:

```lua
-- Remove or change enabled = false to enabled = true
{
  "nvim-java/nvim-java",
  ft = "java",
  -- enabled = true,  -- Enable this
}
```

**Step 6: Install java-debug and java-test**

```bash
# In Neovim
:Mason
# Search: java-debug-adapter
# Press 'i' to install

# Search: java-test
# Press 'i' to install
```

Mason will install these to:
- `~/.local/share/nvim/mason/packages/java-debug-adapter/`
- `~/.local/share/nvim/mason/packages/java-test/`

**Step 7: Configure java-debug bundles**

Update `after/ftplugin/java.lua`:

```lua
-- Add to init_options
local bundles = {}

-- java-debug
vim.list_extend(bundles, vim.split(
  vim.fn.glob("~/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/*.jar"),
  "\n"
))

-- java-test
vim.list_extend(bundles, vim.split(
  vim.fn.glob("~/.local/share/nvim/mason/packages/java-test/extension/server/*.jar"),
  "\n"
))

config.init_options = {
  bundles = bundles
}
```

**Step 8: Test the Setup**

```bash
# Create test Java file
cat > Test.java << 'EOF'
public class Test {
    public static void main(String[] args) {
        System.out.println("Hello from Java 24!");
    }
}
EOF

# Open in Neovim
nvim Test.java

# Check LSP status
:LspInfo

# You should see jdtls attached
```

### 9.2 Plugin Additions

**Add to lazy.nvim plugins:**

```lua
-- In lua/plugins/java.lua (new file)
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  {
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      spring_boot_tools = {
        enable = true,
      },
    },
  },

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vim-test")({
            allow_file_types = { "java" },
          }),
        },
      })
    end,
  },

  -- Coverage
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("coverage").setup({
        auto_reload = true,
        lang = {
          java = {
            coverage_file = vim.fn.getcwd() .. "/target/site/jacoco/jacoco.xml",
          },
        },
      })
    end,
  },

  -- Spring Boot
  {
    "elmcgill/springboot-nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
    },
    ft = "java",
    config = function()
      require("springboot-nvim").setup()
    end,
  },
}
```

### 9.3 Keybindings Integration

**Add to development-algorithm.lua:**

```lua
-- Java-specific test runners
{
  "<leader>Dtr",
  function()
    local ft = vim.bo.filetype
    if ft == "java" then
      -- JUnit test via jdtls
      require('jdtls').test_nearest_method()
    else
      -- Existing logic for other languages
      vim.cmd("!pytest " .. vim.fn.expand("%:p"))
    end
  end,
  desc = "Run test for current file"
}

-- Java debugging
{
  "<leader>dj",
  function()
    require('jdtls').test_nearest_method()
  end,
  desc = "Debug Java Test"
}

-- Coverage
{
  "<leader>Dtc",
  function()
    vim.cmd("!mvn clean test")
    vim.defer_fn(function()
      require("coverage").load(true)
    end, 2000)
  end,
  desc = "Run tests with coverage"
}
```

### 9.4 Update CLAUDE.md

Add Java-specific section to your CLAUDE.md:

```markdown
### Java Development Commands

```vim
" LSP & Code Intelligence
:LspInfo                " Check jdtls status
<leader>ca              " Code actions (generate getters, etc.)
<leader>cf              " Format code (google-java-format)

" Testing
<leader>Dtr             " Run/debug test method (JUnit)
<leader>Dta             " Run all tests (Maven/Gradle)
<leader>Dtc             " Run tests with coverage (JaCoCo)

" Debugging
<leader>dj              " Debug test method
<leader>db              " Toggle breakpoint
<leader>dc              " Continue
<leader>du              " Toggle DAP UI

" Build Tools
<leader>mc              " Maven compile
<leader>mt              " Maven test
<leader>gb              " Gradle build
<leader>gt              " Gradle test

" Spring Boot
<leader>Jr              " Spring Boot run
<leader>Jc              " Spring Boot stop
<leader>Jd              " Spring Boot debug
```
```

---

## 10. Summary and Action Items

### 10.1 Key Findings

1. **jdtls DOES support Java 24** (since version 1.46.0, March 2025)
   - Requires Java 21+ runtime to run the language server
   - Can compile/analyze Java 8-24 projects
   - Solution: Use Java 21 for jdtls, Java 24 for projects

2. **nvim-jdtls is the recommended approach** for your configuration
   - Aligns with KISS principle
   - Configuration as code
   - Consistent with your existing LSP setup
   - Fine-grained control

3. **Testing automation is available** but less visual than VSCode
   - Direct Maven/Gradle integration works well
   - jdtls provides JUnit test runner
   - Neotest + vim-test for UI
   - No native watch mode (use Gradle --continuous)

4. **Debugging is equivalent to VSCode**
   - Same java-debug-adapter
   - nvim-dap + dapui provides full debugging
   - Remote attach for microservices
   - Persistent breakpoints possible

5. **Code quality tools integrate via none-ls**
   - Checkstyle for linting
   - google-java-format for formatting
   - Error Prone for compile-time checks
   - JaCoCo coverage via nvim-coverage

### 10.2 Immediate Action Items

**Priority 1: Enable Java 24 Support**
- [ ] Install Java 21 (for jdtls runtime)
- [ ] Keep Java 24 (for project compilation)
- [ ] Configure multiple JDK runtimes in jdtls
- [ ] Create `after/ftplugin/java.lua`
- [ ] Enable jdtls in `lua/plugins/lsp.lua`

**Priority 2: Setup Debugging**
- [ ] Install java-debug-adapter via Mason
- [ ] Install java-test via Mason
- [ ] Configure bundles in jdtls init_options
- [ ] Enable nvim-java plugin in dap.lua
- [ ] Test debugging with sample Java file

**Priority 3: Testing Automation**
- [ ] Add Maven/Gradle test runners to development-algorithm.lua
- [ ] Setup JUnit test keybindings (jdtls.test_nearest_method)
- [ ] Configure JaCoCo coverage in pom.xml/build.gradle
- [ ] Install nvim-coverage plugin
- [ ] Test coverage visualization

**Priority 4: Code Quality**
- [ ] Install none-ls.nvim
- [ ] Configure google-java-format
- [ ] Setup Checkstyle integration
- [ ] Add Error Prone to Maven compiler plugin
- [ ] Test auto-format on save

**Priority 5: Spring Boot (If Applicable)**
- [ ] Install springboot-nvim plugin
- [ ] Install Spring Boot Tools via Mason
- [ ] Configure DevTools in pom.xml
- [ ] Test hot reload workflow
- [ ] Setup REST client (kulala.nvim)

### 10.3 Long-Term Enhancements

**Productivity Improvements:**
- [ ] Create custom Java snippets (psvm, sout, test)
- [ ] Setup Treesitter text objects for Java
- [ ] Configure Telescope for Java-specific pickers
- [ ] Add project templates for Spring Boot/Maven
- [ ] Document Java workflows in CLAUDE.md

**Workflow Integration:**
- [ ] Integrate with your Zettelkasten (capture Java learnings)
- [ ] Add Java to dual documentation workflow
- [ ] Create DDR template for Java architecture decisions
- [ ] Setup spaced repetition for Java patterns
- [ ] Build Java-specific git archaeology commands

**Team Collaboration:**
- [ ] Share Java setup with team
- [ ] Create .vscode/launch.json templates
- [ ] Document debugging workflows
- [ ] Setup remote debugging for prod issues
- [ ] Create troubleshooting guide

### 10.4 Resources and References

**Official Documentation:**
- Eclipse JDT.LS: https://github.com/eclipse-jdtls/eclipse.jdt.ls
- nvim-jdtls: https://github.com/mfussenegger/nvim-jdtls
- nvim-dap: https://github.com/mfussenegger/nvim-dap
- nvim-java: https://github.com/nvim-java/nvim-java

**Guides and Tutorials:**
- Neovim Java IDE Setup: https://sookocheff.com/post/vim/neovim-java-ide/
- LazyVim Java Series: https://www.lorenzobettini.it/2024/11/neovim-and-java-with-lazyvim-part-1-initial-configuration/
- Setup Neovim for Java Development: https://zignar.net/2019/11/21/setup-neovim-for-java-development/

**Community Resources:**
- nvim-jdtls Wiki: https://github.com/mfussenegger/nvim-jdtls/wiki
- nvim-dap Wiki: https://github.com/mfussenegger/nvim-dap/wiki
- Neovim Discourse (Java): https://neovim.discourse.group/

**Tools and Extensions:**
- java-debug: https://github.com/microsoft/java-debug
- java-test: https://github.com/microsoft/vscode-java-test
- google-java-format: https://github.com/google/google-java-format
- Checkstyle: https://checkstyle.org/
- JaCoCo: https://www.jacoco.org/

---

## Conclusion

Modern Java development in Neovim for 2025 is **fully viable** and can match or exceed VSCode's Java extension capabilities, with the key advantage of speed, keyboard-centric workflow, and deep customization. The main "gotcha" with Java 24 is solved by using Java 21 to run jdtls while targeting Java 24 for projects.

Your existing configuration philosophy (KISS, configuration as code, keyboard-first) makes **nvim-jdtls the ideal choice** over nvim-java. The setup requires initial configuration but provides long-term benefits in productivity and workflow integration with your Development Algorithm and Zettelkasten systems.

The immediate next step is to install Java 21, configure multi-JDK support, and enable jdtls. From there, incrementally add debugging, testing automation, and code quality tools as needed for your Java projects.

---

**Research conducted:** November 8, 2025
**Status:** Ready for implementation
**Next review:** After Java 25 release or major jdtls updates
