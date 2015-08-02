json.extract! @employment, :id, :hours_per_week, :created_at, :updated_at
json.extract! @employment.gsi, :name, :email, :signed_in_before
