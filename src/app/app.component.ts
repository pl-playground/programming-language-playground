import { Component } from '@angular/core';
import { parse } from 'querystring';


const defaults = {
  interp1:  '',
  interp2: '',
  interp3: '',
};

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
})
export class AppComponent {
  readOnly = false;
  current_interpreter = 'interp1';
  mode = 'scheme';
  options: any = {
    lineNumbers: true,
    mode: this.mode,
  };
  defaults = defaults;
  code = '';
  value = '';


  // handleChange: Event -> void
  // EFFECT: changes `this.code` to the latest updated code
  // called from ngModelChange from ngModelChange
  handleChange(event) {
    this.code = event.toString();
  }

  // -> EFFECT 
  // sends a request object to server and gets output
  run() {

    var req_obj = Object.create(null, {});
    req_obj.interpret_name = this.current_interpreter;
    req_obj.user_input = this.code;

    console.log(req_obj);

    const xhr = new XMLHttpRequest();
    xhr.open("POST", "http://127.0.0.1:8000/code/", false);
    xhr.setRequestHeader('Content-Type', 'application/json');
    // xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    // xhr.onload = function() {
    //      console.log(JSON.parse(xhr.responseText).output);
    //   };
    
    xhr.send(JSON.stringify(req_obj))
    
    this.value = JSON.parse(xhr.responseText).output
  }
}
