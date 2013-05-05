  mongoose = require('mongoose');

console.log("Required Mongoose, attempting to connect");

mongoose.connect('mongodb://localhost/tliWin');

console.log("Connect initiated");

var db = mongoose.connection;
var assignmentSchema, Assignment, assignments;

db.on('error', console.error.bind(console, "Connection error: "));
db.once("open", function() {
	console.log("Connection open. Creating schema.");
	assignmentSchema = mongoose.Schema( {
		name: String,
		date: Date,
		postURL: String,
		reflectURL: String,
		postText: Array,
		reflectText: String,
	});
	console.log("Schema created. Building model.");
	exports.Assignment = mongoose.model("Assignment", assignmentSchema);
	console.log("Model created. Finding items:");
	
	exports.Assignment.find(function(err, as) {
		if(err) {
			console.log(err);
		}
		else {
			assignments = as;
			console.log(assignments);
		}
	});
});