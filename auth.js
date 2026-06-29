// Shared auth helper: simple credential check + session guard via localStorage
// Used by both admin & UMKM panels.
(function() {
  const KEY = 'simumkmSession';
  const CREDS = {
    'admin@umkm.go.id':  { pw: 'admin123',  role: 'admin', name: 'Dirga Admin', initial: 'DA' },
    'busari@umkm.go.id': { pw: 'umkm123',   role: 'umkm',  name: 'Bu Sari',     initial: 'BS' },
  };

  window.SIMAuth = {
    login(email, pw) {
      const c = CREDS[email.toLowerCase().trim()];
      if (!c || c.pw !== pw) return null;
      const session = { email, role: c.role, name: c.name, initial: c.initial, ts: Date.now() };
      localStorage.setItem(KEY, JSON.stringify(session));
      return session;
    },
    logout() { localStorage.removeItem(KEY); },
    getSession() {
      try { return JSON.parse(localStorage.getItem(KEY) || 'null'); } catch (e) { return null; }
    },
    // Guard: redirect to login if not authenticated for given role
    guard(role) {
      const s = this.getSession();
      const path = location.pathname.toLowerCase();
      // Skip guard on login/logout pages themselves
      if (path.endsWith('/login.html') || path.endsWith('/logout.html')) return s;
      if (!s || s.role !== role) {
        location.replace('login.html');
        return null;
      }
      return s;
    },
    credentialsHint() {
      return CREDS;
    }
  };

  // Auto-guard based on path
  const isUMKM = /\/umkm\//i.test(location.pathname);
  const isDKUK = /\/dkukmpp\//i.test(location.pathname);
  if (isUMKM) window.SIMAuth.guard('umkm');
  else if (isDKUK) window.SIMAuth.guard('admin');
})();
