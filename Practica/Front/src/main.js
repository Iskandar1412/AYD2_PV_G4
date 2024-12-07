import { mount } from 'svelte'
import './app.css'
import './lib/styles/Dash.css'
import App from './App.svelte'

const app = mount(App, {
  target: document.getElementById('app'),
});

export default app;
