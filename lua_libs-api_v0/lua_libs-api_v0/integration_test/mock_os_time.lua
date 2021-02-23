os.__advance_time = function(time)
  assert(type(time) == "number", "time must be numeric")
  assert(time >= 0, "time must only increase")
  os.__mock_time = os.__mock_time + time
end

os.__set_time = function(value)
  os.__mock_time = value
end

os.time = function()
  return os.__mock_time
end
