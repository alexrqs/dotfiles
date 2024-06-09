-- NOTE: how to use
-- :RainbowAlign will create some sort of table
-- :CSVLint will lint the csv file

-- NOTE: to query use RBQL (Rainbow Query Language)
-- example:
-- :Select a1, a2, a3 where a1 == 'foo'

return {
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
}
