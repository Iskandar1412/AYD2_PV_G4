import { writable } from 'svelte/store';

const storedUser = JSON.parse(localStorage.getItem('user')) || null;

export const user = writable(storedUser);
export const isAuthenticated = writable(storedUser !== null);

export function loginUser(usuario) {
    const userInfo = usuario;
    localStorage.setItem('user', JSON.stringify(userInfo));
    user.set(userInfo);
    isAuthenticated.set(true);
}

export function logoutUser() {
    localStorage.removeItem('user');
    user.set(null);
    isAuthenticated.set(false);
}