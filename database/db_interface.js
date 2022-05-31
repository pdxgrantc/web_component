const { count } = require('console');
const fs = require('fs');
const { exit, title } = require('process');

class Database {
    constructor() {
        this.items = [];
        this.readIn();
    }

    new_item(new_title, new_day, new_month, new_year, new_description) {
        var day_created = this.get_current_date();
 
        let new_post = {
            title: String(new_title),
            date_created_day: String(day_created.day),
            date_created_month: String(day_created.month),
            date_created_year: String(day_created.year),
            date_due_day: String(new_day),
            date_due_month : String(new_month),
            date_due_year: String(new_year),
            description: String(new_description)
        };
        this.items.push(new_post);
        
        const file_cache = JSON.stringify(this.items, null, 4);
        this.writeToFile(file_cache);
    }
    
    get_current_date() {
        var d = new Date()
        var new_date = {
            //keyTime: d.getTime(),
            year: d.getFullYear(),
            month: d.getMonth(),
            day: d.getDate(),
        }
        return new_date;
    }

    create_due_date(new_day, new_month, new_year) {
        var new_date = {
            year: new_year,
            month: new_month,
            day: new_day
        }
        return new_date;
    }

    writeToFile(file_cache) {
        fs.writeFileSync(__dirname + '/data/db.json', file_cache);
    }

    deleteContents() {
        fs.unlinkSync(__dirname + '/data/db.json');
    }

    readIn() {
        let db_json = require(__dirname + '/data/db.json');
        this.items = db_json;
    }

    delete_item(title) {
        for (let i = 0; i < this.items.length; i++) {
            if (this.items[i].title == title) {
                for (let j = 0; j < this.items[i].posts.length; j++) {
                    this.items.splice(j, 1);
                    this.writeToFile();
                    return true;
                }
            }
        }
        return false;
    }
    
    get_items() {
        return this.items;
    }
}

module.exports.Database = Database;
