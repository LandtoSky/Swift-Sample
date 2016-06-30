# Requests templates

## Create a new property

URL:`/properties`

Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
{
   "id":String,
   "type": String //house, apartment,parking, land, retail, office, project
   "negotiation": String //sale, let
 }
 ```

## Description
URL:`/properties/PROPERTY-ID`

Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    "op":"add",
    "path":"/description",
    "value":{
        "title": String,
        "description": String
    }
]
```

--
Send using form-style

## Location
URL:`/properties/PROPERTY-ID`
Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
	{
	    "op":"add",
	    "path":"/location",
	    "value":{
	        "street": String,
	        "street_2": String,
	        "number": String,
	        "addition": String,
	        "box": String,
	        "floor": String,
	        "city": String,
	        "province_or_county": String,
	        "country": String,
	        "public": Boolean,
	        "geo: {
	        	"latitude": Double,
	        	"longitude": Double
	        }
	    }
	}
]
```

--
The empty or null values are deleted from this request

Send using form-style

## Price
URL:`/properties/PROPERTY-ID`

Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    {
        "op":"add",
        "path":"/price",
        "value": {
            "costs" : String,
            "taxes" : String,
            "published_price" : {
                "amount": Float,
                "currency": String //EUR, GBP
            }
        }
    }
]
```

--
Send using form-style

## Legal & Docs

URL:`/properties/PROPERTY-ID`
Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    {
        "op":"add",
        "path":"/energy",
        "value":{
            "notes" : String,
            "purchased_year" : Int        
         }
    },
    {
        "op":"add",
        "path":"/tenant_contract/start_date",
        "value": String //Format: YYYY-MM-DD
    },
    {
        "op":"add",
        "path":"/tenant_contract/end_date",
        "value": String //Format: YYYY-MM-DD
    }
]
```

--
The contract dates requests are sent individually (field-by-field). The notes and purchased year are send together (form-style).

## Room

URL:`/properties/PROPERTY-ID`
Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    {
        "op":"add",
        "path":"/structure/floors",
        "value": Int
    },
    {
        "op":"add",
        "path":"/amenities",
        "value": [String] //pool, attic, basement, terrace, garden, parking, lift, guesthouse, electrical_gate, manual_gate, fence, remote_control, key_card, code, climate_control, water_access, utilities_access, sewer_access, drainage, road_access
    },
    {
        "op":"add",
        "path":"/general_condition",
        "value": String //poor, fair, good, mint, new
    },
    {
        "op":"add",
        "path":"/orientation/garden",
        "value": String //N, NE, E, SE, S, SW, W, NW
    },    
    {
        "op":"add",
        "path":"/orientation/terrace",
        "value": String //N, NE, E, SE, S, SW, W, NW
    }      
]
```

--
Send using field-by-field

### Add rooms
URL:`/properties/PROPERTY-ID`

Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    {
        "op":"add",
        "path":"/"op":"add", "path":"/structure/rooms/ROOM-ID",
        "value": {
            "size" : "0.0" //Default value,
            "type" : String //bedroom, bathroom, wc, kitchen, living_room,
            "units" : String //sq_m, sq_ft,
            "size_description": ""
        }
    },
    ...
]
```

### Remove rooms
URL:`/properties/PROPERTY-ID`

Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    {
        "op":"remove",
        "path":"/structure/rooms/ROOM-ID"
    },
    ...
]
```
## Features

URL:`/properties/PROPERTY-ID`

Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    {
        "op":"add",
        "path":"/conditions/bathroom",
        "value": String //poor, fair, good, mint, new
    },
    {
        "op":"add",
        "path":"/conditions/kitchen",
        "value": String //poor, fair, good, mint, new
    },   
    {
        "op":"add",
        "path":"/building/construction/year",
        "value": Int
    },    
    {
        "op":"add",
        "path":"/building/construction/architect",
        "value": String
    },    
    {
        "op":"add",
        "path":"/building/renovation/year",
        "value": Int
    },    
    {
        "op":"add",
        "path":"/building/renovation/description",
        "value": String
    },    
]
```

--
Send using field-by-field

### List of Features
URL:`/properties/PROPERTY-ID`

Header: `[
		"Content-Type": "application/json-patch+json",
       "Authorization":"Bearer ACCESS_TOKEN"
 ]`

Parameters:
```
[
    {
        "op":"add",
        "path":"/comfort/FEATURE //home_automation, water_softener, fireplace, walk_in_closet, home_cinema, wine_cellar, sauna, fitness_room",
        "value": Boolean
    },
    {
        "op":"add",
        "path":"/features/ecology/FEATURE //double_glazing, solar_panels, solar_boiler, insulated_roof, rainwater_harvesting",
        "value": Boolean
    },
    {
        "op":"add",
        "path":"/features/energy/FEATURE //gas, fuel, electricity",
        "value": Boolean
    },
    {
        "op":"add",
        "path":"/features/security/FEATURE //alarm, concierge, video_surveillance",
        "value": Boolean
    },   
    {
        "op":"add",
        "path":"/features/heating-cooling/FEATURE //central_heating, floor_heating, air_conditioning",
        "value": Boolean
    },
    {
        "op":"add",
        "path":"/permissions/FEATURE //construction, planning, farming, fishing",
        "value": Boolean
    },
]
```

--
Send using field-by-field
