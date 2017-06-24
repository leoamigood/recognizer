require 'google/cloud/speech'

if Rails.env.production?
  $speech = Google::Cloud::Speech.new
end
