-- Default local entry: MlsProbe. Keep its unqualified requires in its directory.
package.path = package.path:gsub('%?', 'MlsProbe/?') .. ';' .. package.path
require('MlsProbe.main')
