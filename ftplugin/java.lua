local jdtls = require 'jdtls'

local root_markers = {
  'gradlew',
  'mvnw',
  '.git',
  'pom.xml',
  'build.gradle',
}
local root_dir = vim.fs.root(0, root_markers)
if not root_dir then
  return
end

local data_path = vim.fn.stdpath 'data'

-- jdtls paths
local jdtls_path = vim.fn.expand '$MASON/packages/jdtls'
local jdtls_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local ws_dir = data_path .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h')

-- java-debug-adapter
local java_debug_adapter_path = vim.fn.expand '$MASON/packages/java-debug-adapter/extension/server'
local java_debug_adapter_jar = vim.fn.glob(java_debug_adapter_path .. '/com.microsoft.java.debug.plugin-*.jar', true, false)

local bundles = {
  java_debug_adapter_jar,
}

-- java-test
local java_test_path = vim.fn.expand '$MASON/packages/java-test/extension/server'
local java_test_jars = vim.fn.split(vim.fn.glob(java_test_path .. '/*.jar'), '\n')
local java_test_jars_exclude = {
  'com.microsoft.java.test.runner-jar-with-dependencies.jar',
  'jacocoagent.jar',
}

for _, java_test_jar in ipairs(java_test_jars) do
  local fname = vim.fn.fnamemodify(java_test_jar, ':t')
  if not vim.tbl_contains(java_test_jars_exclude, fname) then
    table.insert(bundles, java_test_jar)
  end
end

local config = {
  cmd = {
    '/usr/lib/jvm/java-21-openjdk/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=WARNING',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    jdtls_jar,
    '-configuration',
    jdtls_path .. '/config_linux',
    '-data',
    ws_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      completion = {
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
      },

      configuration = {
        runtimes = {
          { name = 'JavaSE-11', path = '/usr/lib/jvm/java-11-openjdk' },
          { name = 'JavaSE-21', path = '/usr/lib/jvm/java-21-openjdk' },
        },
      },

      format = {
        enabled = true,
        settings = {
          url = root_dir .. '/style.xml',
          profile = 'Custom',
        },
      },
    },
  },
  init_options = {
    bundles = bundles,
  },
}

jdtls.start_or_attach(config)
