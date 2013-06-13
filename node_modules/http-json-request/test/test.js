var
  http = require('../lib/http-json'),
  assert  = require('chai').assert,
  express = require('express'),
  app = express(),
  port = 3010;
  
app.use(express.bodyParser());  
//app.use(express.logger());
app.get('/', function(req, res){res.send(req.body);});
app.get('/path', function(req, res){res.json(req.body);});
app.put('/path', function(req, res){res.json(req.body);});
app.post('/path', function(req, res){res.send(req.body);});
app.delete('/path', function(req, res){res.json(req.body);});
//app.search('/path', function(req, res){res.json(req.body);});
app.listen(port);
console.log('Express server started on port %s', port);

http.defaultPort(3010);
http.defaultHost('localhost');


describe('Get test',function(){
  it('getJSON(host, port, path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.getJSON('localhost', port, '/',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object');
       assert.equal(json.ok, true);
       done();
    });
  });
  it('getJSON (host, port, path, cb)', function(done){
    //Parameters: host, port, path, cb
    http.getJSON('localhost', port, '/',  function(error, json){ 
      assert.equal(error, null);
       assert.typeOf(json, 'object');
       assert.equal(JSON.stringify(json), "{}");
       done();
    });
  });
  it('getJSON(host, port, cb)', function(done){
    //Parameters: host, port, cb
    http.getJSON('localhost', port, function(error, json){ 
      assert.equal(error, null);
      assert.typeOf(json, 'object');
      assert.equal(JSON.stringify(json), "{}");
      done();
    });
  });
  it('getJSON(path, cb)', function(done){
    //Parameters: path, cb
    http.getJSON('/', function(error, json){ 
      assert.equal(error, null);
      assert.typeOf(json, 'object');
      assert.equal(JSON.stringify(json), "{}");
      done();
    });
  });
});


describe('Post test',function(){
  it('postJSON(host, port, path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.postJSON('localhost', 3010, '/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object', 'json');
       assert.equal(json.ok, true, 'json.ok=true');
       done();
    });
  });
  it('postJSON(path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.postJSON('/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object');
       assert.equal(json.ok, true);
       done();
    });
  });
  it('postJSON(json, path,  cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.postJSON({ok: {jeah: true}}, '/path',  function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object');
       assert.equal(json.ok.jeah, true);
       done();
    });
  });
  /*it('postJSON(json, path,  cb)-timeout', function(done){
    //Parameters: host, port, path, json, cb 
    http.postJSON({ok: {jeah: true}}, '/invalidpath',  function(error, json){ 
       console.log(error);
       assert.equal(error, 'timeout');
       assert.equal(json, null);
       done();
    });
  });*/
});


describe('Put test',function(){
  it('putJSON(host, port, path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.putJSON('localhost', 3010, '/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object', 'json');
       assert.equal(json.ok, true, 'json.ok=true');
       done();
    });
  });
  it('postJSON(path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.putJSON('/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object');
       assert.equal(json.ok, true);
       done();
    });
  });
})

describe('Delete test',function(){
  it('deleteJSON(host, port, path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.deleteJSON('localhost', 3010, '/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object', 'json');
       assert.equal(json.ok, true, 'json.ok=true');
       done();
    });
  });
  it('deleteJSON(path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.deleteJSON('/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object');
       assert.equal(json.ok, true);
       done();
    });
  });
})

/*
describe('Search test',function(){
  it('searchJSON(host, port, path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.searchJSON('localhost', 3010, '/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object', 'json');
       assert.equal(json.ok, true, 'json.ok=true');
       done();
    });
  });
  it('searchJSON(path, json, cb)', function(done){
    //Parameters: host, port, path, json, cb 
    http.searchJSON('/path',  {ok: true}, function(error, json){ 
       assert.equal(error, null, error);
       assert.typeOf(json, 'object');
       assert.equal(json.ok, true);
       done();
    });
  });
})*/