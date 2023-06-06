import { createRouter, createWebHistory } from 'vue-router'
import store from '@/store';

const routes = [
  {
    path: '/',
    name: 'HomePage',
    component: () => import('@/views/HomePage.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/plants',
    name: 'PlantList',
    component: () => import('@/views/PlantList.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/plants/add',
    name: 'PlantAdd',
    component: () => import('@/components/modals/PlantAddModal.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/plantlogs',
    name: 'PlantlogList',
    component: () => import('@/views/PlantlogList.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/setting',
    name: 'UserCard',
    component: () => import('@/views/UserCard.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/edituser',
    name: 'UserEdit',
    component: () => import('@/views/UserEdit.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/login',
    name: 'UserLogin',
    component: () => import('@/views/UserLogin.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, from, next) => {
  if (to.matched.some((record) => record.meta.requiresAuth) && !store.state.user) {
    next({ name: 'UserLogin' });
  } else if(to.name === "UserLogin" && store.state.user) {
    //로그인 정보가 존재하는 상태에서 로그인 페이지 요청일 경우 메인 페이지로 리다이렉트
    next({ name: "HomePage" });
  } else {
    next();
  }
});

export default router