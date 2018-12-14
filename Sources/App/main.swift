import Vapor
import VaporMySQL

let mysql = VaporMySQL.Provider.self

let drop = Droplet(preparations: [Building.self, Room.self, Equipment.self], providers: [mysql])



drop.post("equipment") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    guard let room = request.data["room"]?.string else {
        throw Abort.badRequest
    }
    guard let serialNumber = request.data["serialNumber"]?.int else {
        
        throw Abort.badRequest
    }
    if let equipmentFound = try Equipment.query().filter("serialNumber", serialNumber).first() {
        throw Abort.custom(status: .badRequest, message: "You've already have an equipment with the \(serialNumber) Serial Number. Please check the serial number")
    }else{
        if let roomFound = try Room.query().filter("name", room).first() {
            
            guard let roomId = try Room.query().filter("name", room).first()?.id! else {
                throw Abort.badRequest
            }
            
            var equipment = Equipment(name: name, roomId: roomId, serialNumber: serialNumber)
            
            try equipment.save()
            
            return equipment
        }else{
            throw Abort.custom(status: .badRequest, message: "There is no room named \(room). Try to add the romm in different one")
        }
    }
}


drop.post("room") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    guard let building = request.data["building"]?.string else {
        throw Abort.badRequest
    }
    
    if let roomFound = try Room.query().filter("name", name).first() {
        throw Abort.custom(status: .badRequest, message: "You've already have a room named \(name). Try to create a different one")
    }else{
        
        if let houseFound = try Building.query().filter("name", building).first() {
            
            guard let buildingId = try Building.query().filter("name", building).first()?.id! else {
                throw Abort.badRequest
            }

            var room = Room(name: name, buildingId: buildingId)
            
            try room.save()
            
            return room
        }else{
            throw Abort.custom(status: .badRequest, message: "There is no building named \(building). Try to add the room in different one")
        }
    }
}

drop.post("building") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    guard let color = request.data["color"]?.string else {
        throw Abort.badRequest
    }
    guard let address = request.data["address"]?.string else {
        throw Abort.badRequest
    }
    
    if let buildingFound = try Building.query().filter("name", name).first() {
        throw Abort.custom(status: .badRequest, message: "You've already created a building named  \(name). Try to create a different one")
    }
    
    var building = Building(name: name, color: color, address: address)
    
    try building.save()
    
    return building
    
}

//drop.post("deletePokemon") { request in
//    guard let id = request.data["id"]?.string else {
//        throw Abort.badRequest
//    }
//    
//    if let find = try Pokemon.find(id) {
//        throw Abort.custom(status: .badRequest, message: "There was no pokemon with the \(id) ID")
//    }
//
//    guard let founded = try Pokemon.find(id) else {
//        throw Abort.custom(status: .badRequest, message: "There was no pokemon with the \(id) ID")
//        //return "what the hell"
//    }
//    
//    try founded.delete()
//    let deleted:Dictionary<String, Any> = ["delete":"succes","deletedPokemon": founded]
//    
//    return founded //Node(dictionaryLiteral: ("this pokemon is deleted", founded.makeNode()))
//    
//}


drop.get("Hello") { request in
    return "Hello beautifull and amazing world!!!!!"
}

drop.get("rooms") { request in
    
    return try JSON(node: Room.all())
}

drop.get("buildings") { request in
    
    return try JSON(node: Building.all())
}

drop.get("equipments") { request in
    
    return try JSON(node: Equipment.all())
}

drop.post("buildingOfRoom") { request in
    
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    
    if let room = try Room.query().filter("name", name).first() {
        let building = try room.building().get()! //pokemon.house().get()!
        return building
    }
    return "no tengo idea"
}

drop.post("roomOfEquipment") { request in
    
    guard let serialNumber = request.data["serialNumber"]?.string else {
        throw Abort.badRequest
    }
    
    if let equipment = try Equipment.query().filter("serialNumber", serialNumber).first() {
        let room = try equipment.room().get()! //room.building().get()! //pokemon.house().get()!
        return room
    }
    return "no tengo idea"
}



drop.post("roomsOfBuilding") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    if let building = try Building.query().filter("name", name).first() {
        let rooms = try building.rooms().all()
        return try JSON(node: rooms)
    }
    return "no tengo idea"
}


drop.post("equipmentsOfRoom") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    
    if let room = try Room.query().filter("name", name).first() {
        let equipments = try room.equipments().all() //building.rooms().all()
        return try JSON(node: equipments)
    }
    return "no tengo idea"
}


//drop.get { req in
//    return try drop.view.make("welcome", [
//    	"message": drop.localization[req.lang, "welcome", "title"]
//    ])
//}

//drop.resource("posts", PostController())

drop.run()
