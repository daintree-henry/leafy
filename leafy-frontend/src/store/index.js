import { createStore } from 'vuex';

export default createStore({
  state: {
    user: null,
    popup: {
      message: "",
      status: "",
      visible: false,
      showingSecond: 3000,
    },
  },
  mutations: {
    setPopup(state, payload) {
      state.popup.message = payload.message;
      state.popup.status = payload.status;
      state.popup.showingSecond = payload.showingSecond;
      state.popup.visible = payload.visible;
    },
    setUser(state, user) {
      state.user = user;
    },
  },
  actions: {
    loginUser({ commit }, user) {
      commit('setUser', user);
    },
    logoutUser({ commit }) {
      commit('setUser', null);
    },
    showPopup({ commit }, payload) {
      commit("setPopup", {
        ...payload,
        visible: true,
      });
      setTimeout(() => {
        commit("setPopup", {
          ...payload,
          visible: false,
        });
      }, payload.showingSecond);
    },
  },
});

