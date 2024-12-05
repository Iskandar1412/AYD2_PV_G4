import { writable } from "svelte/store";

export const isAuthenticated = writable(false);

export const login = (userData) => {
    isAuthenticated.set(true)
    localStorage.setItem('isAuthenticated', 'true');
    localStorage.setItem('userData', JSON.stringify(userData))
}

export const logout = () => {
    isAuthenticated.set(false)
    localStorage.removeItem('isAuthenticated')
    localStorage.removeItem('userData')
}

export const getUser = () => {
    const userData = localStorage.getItem('userData')
    return userData ? JSON.parse(userData) : null
}