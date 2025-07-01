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

local jdtls_path = data_path .. '/mason/packages/jdtls'
local jdtls_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local ws_dir = data_path .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h')

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
          { name = 'JavaSE-8', path = '/usr/lib/jvm/java-8-openjdk' },
          { name = 'JavaSE-11', path = '/usr/lib/jvm/java-11-openjdk' },
          { name = 'JavaSE-17', path = '/usr/lib/jvm/java-17-openjdk' },
          { name = 'JavaSE-21', path = '/usr/lib/jvm/java-21-openjdk' },
          { name = 'JavaSE-24', path = '/usr/lib/jvm/java-24-openjdk' },
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
    bundles = {},
  },
}

jdtls.start_or_attach(config)
