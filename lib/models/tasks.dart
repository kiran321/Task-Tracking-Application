
class Task {
	int _id;
	String _title;
	String _description;
	var _date; 

	Task(this._title, this._date, [this._description]);
	Task.withId(this._id, this._title, this._date, [this._description]);

	int get id => _id;
	String get title => _title;
	String get description => _description;
	get date => _date; 

	set title(String newTitle) {
		if (newTitle.length <= 50) {
			this._title = newTitle;
		}
	}

	set description(String newDescription) {
		if (newDescription.length <= 250) {
			this._description = newDescription;
		}
	}

	set date(var newDate) {
	this._date = newDate; 
	}

	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['description'] = _description;
		map['date'] = _date;
	
  	return map;
	}

	Task.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['title'];
		this._description = map['description'];
		this._date = map['date'];
	}
}









