const loki = require('lokijs');

let counter = 0;
const db = new loki('booking.db');
const booking = db.addCollection('bookings');

exports.getIDs = function(query, callback) {
  try {
    // Convert nedb-style query to LokiJS query
    const results = booking.find(query);
    callback(null, results);
  } catch (err) {
    callback(err);
  }
};

exports.get = function(id, callback) {
  try {
    const result = booking.findOne({ bookingid: parseInt(id) });
    callback(null, result);
  } catch (err) {
    callback(err, null);
  }
};

exports.create = function(payload, callback) {
  try {
    counter++;
    payload.bookingid = counter;
    booking.insert(payload);
    callback(null, payload);
  } catch (err) {
    callback(err);
  }
};

exports.update = function(id, updatedBooking, callback) {
  try {
    const doc = booking.findOne({ bookingid: parseInt(id) });
    if (!doc) {
      return callback(new Error(`Booking ${id} not found`));
    }
    Object.assign(doc, updatedBooking);
    booking.update(doc);
    callback(null);
  } catch (err) {
    callback(err);
  }
};

exports.delete = function(id, callback) {
  try {
    const doc = booking.findOne({ bookingid: parseInt(id) });
    if (!doc) {
      return callback(new Error(`Booking ${id} not found`));
    }
    booking.remove(doc);
    callback(null);
  } catch (err) {
    callback(err);
  }
};

exports.deleteAll = function(callback) {
  try {
    counter = 0;
    booking.clear();
    callback(null);
  } catch (err) {
    callback(err);
  }
};

exports.search = function(queryParams, callback) {
  try {
    let results = booking.find();

    if (queryParams.firstname) {
      const qFirstname = queryParams.firstname.toLowerCase();
      results = results.filter(b => b.firstname && b.firstname.toLowerCase() === qFirstname);
    }

    if (queryParams.lastname) {
      const qLastname = queryParams.lastname.toLowerCase();
      results = results.filter(b => b.lastname && b.lastname.toLowerCase() === qLastname);
    }

    if (queryParams.checkin) {
      const qCheckinDate = new Date(queryParams.checkin);
      if (isNaN(qCheckinDate.getTime())) {
        return callback(new Error('Invalid checkin date value'));
      }
      results = results.filter(b => {
        if (!b.bookingdates || !b.bookingdates.checkin) return false;
        const bCheckinDate = new Date(b.bookingdates.checkin);
        return bCheckinDate >= qCheckinDate;
      });
    }

    if (queryParams.checkout) {
      const qCheckoutDate = new Date(queryParams.checkout);
      if (isNaN(qCheckoutDate.getTime())) {
        return callback(new Error('Invalid checkout date value'));
      }
      results = results.filter(b => {
        if (!b.bookingdates || !b.bookingdates.checkout) return false;
        const bCheckoutDate = new Date(b.bookingdates.checkout);
        return bCheckoutDate <= qCheckoutDate;
      });
    }

    callback(null, results);
  } catch (err) {
    callback(err);
  }
};