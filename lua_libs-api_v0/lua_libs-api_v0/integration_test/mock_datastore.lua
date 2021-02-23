local json = require "dkjson"
local utils = require "st.utils"

datastore = {}
datastore.__data = {}

function datastore.get()
    return json.encode(datastore.__data)
end

function datastore.set(data)
    datastore.__data = json.decode(data)
end

function datastore.__reset()
    for k, _ in pairs(datastore.__data) do
        datastore.__data[k] = nil
    end
end

function datastore.__assert_equal(tab)
    return utils.stringify_table(datastore.__data) == utils.stringify_table(tab)
end

return datastore