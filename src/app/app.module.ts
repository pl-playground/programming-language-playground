import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { MdoButtonModule } from '@ctrl/ngx-github-buttons';
import { CodemirrorModule } from '../lib/public_api';
import { AppComponent } from './app.component';

@NgModule({
  declarations: [AppComponent],
  imports: [BrowserModule, FormsModule, CodemirrorModule, MdoButtonModule],
  bootstrap: [AppComponent]
})
export class AppModule {}
