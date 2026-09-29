## NEAP Collaborators

For now, a table of dummy values was generated in [this document](https://docs.google.com/spreadsheets/d/17LrcAj5mCkFsZmxLHbMOAuDRJjjDmvpP-mOJxg-79KU/edit?gid=0#gid=0) to mimic Google Forms output.

### Assumptions:

* Input will be a Google Spreadsheet output of a Google Form
* The spreadsheet columns and values will be based on [the document the group generated](https://docs.google.com/document/d/196qg8miAepwdIGq5ys9pvybL9KrkOfWGxFsjYOZBmro/edit?tab=t.0)
* In the Google Form, people will be able to use check boxes to choose multiple values of things such as:
  + Organization
  + Region
  + Topical Expertise
  + Technical Skills
  + Products worked on
* The Google Form output for checkboxes is a comma separated list enclosed in quotation marks

### The demo page has two ways to view the tags (see the left sidebar under "Collaborators Tags Tests" - awkward wording!) 

* By Technical Expertise (see right sidebar)
  + Tags are Technical Expertise and other filtering is done by using the search/Filter box or Order-by features.
  + Since the table is visible, it's easy to see examples of values and use the search box to filter by anything (eg try "baking" or "California")
  + Note that by using the "Order By" dropdown, you can also sort a column in ascending or descending order

* By Multiple columns: Any number of column values can be combined into a set of tags in the right sidebar

This is vanilla Quarto.  If people want fancier filtering, there are documented, straightforward ways to configure custom listings using JavaScript.