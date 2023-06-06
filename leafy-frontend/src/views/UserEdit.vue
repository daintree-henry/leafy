<template>
  <div class="user-edit-container">
    <h2>사용자 정보 수정</h2>
    <form @submit.prevent="updateUser">
      <div>
        <label for="name">이름:</label>
        <input id="name" v-model="name" type="text" required />
      </div>
      <div>
        <label for="password">새 비밀번호:</label>
        <input id="password" v-model="password" type="password" required />
      </div>
      <button type="submit">수정하기</button>
    </form>
  </div>
</template>

<script>
import { toRefs, reactive, computed } from 'vue';
import api from '@/api/api';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';

export default {
  name: 'UserEdit',
  setup() {
    const router = useRouter();
    const store = useStore();

    const user = computed(() => store.state.user);

    const editUser = reactive({
      name: user.value.name,
      password: '',
    });

    const updateUser = async () => {
      try {
        const userId = user.value.userId; 
        await api.put(`/api/v1/users/${userId}`, editUser);
        alert('사용자 정보가 성공적으로 수정되었습니다. 다시 로그인 해주세요.');
        store.dispatch('logoutUser');
        router.push({ name: 'HomePage' });
      } catch (error) {
        console.error('사용자 정보 수정 중 오류가 발생했습니다.', error);
        alert('사용자 정보 수정 중 오류가 발생했습니다.');
      }
    };

    return {
      updateUser,
      ...toRefs(editUser),
    };
  },
};
</script>

<style scoped>
.user-edit-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: auto;
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 500px;
  padding: 1rem;
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

form div {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-bottom: 1rem;
}

form label {
  font-weight: bold;
  color: #4c4c4c;
  margin-bottom: 0.5rem;
}

form input {
  flex-basis: 100%;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #f5f5f5;
  transition: background-color 0.2s;
}

form input:focus {
  background-color: #ffffff;
  outline: none;
  border-color: #8fbc8f;
}

button {
  padding: 0.5rem 1rem;
  background-color: #8fbc8f;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.2s, box-shadow 0.2s;
}

button:hover {
  background-color: #7aab7a;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
</style>