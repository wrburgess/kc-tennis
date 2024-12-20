# Lessons From Dev

## Turbo and Downloads

* For a controller action that downloads a file, such as an xlsx file, you need to turn off turbo with this configuration on the link used to activate the download:

```html
<a class="btn btn-secondary float-end me-2" role="button" data-turbo="false" data-turbo-method="get" href="/admin/links/export_xlsx">
  <i class="bi-file-spreadsheet"></i>
  Download
</a>
```

## Turbo and UJS

* Rails used ujs for x
* Now, Rails uses hotwire/turbo to solve the same problem
* In Rails 8+ buttons and links using methods other than GET or POST need to be configured as such:

```html
<a class="btn btn-secondary float-end me-2" role="button" data-turbo="true" data-turbo-method="get" href="/admin/links/export_xlsx">
  <i class="bi-file-spreadsheet"></i>
  Download
</a>
```
