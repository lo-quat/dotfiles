local utils = require('utils')

utils.create_augroups({
  slim_highlight = {
    { 'BufRead', '*.slim', 'setfiletype slim' }
  }
})
