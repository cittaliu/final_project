json.array!(@companies) do |company|
  json.name        company.name
  json.website     book.website
end
