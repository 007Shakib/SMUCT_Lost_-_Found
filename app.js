/**
 * SMUCT Lost & Found Portal - Interactive Mobile Skeleton Logic (app.js)
 * Derived from SRS Document v1.0 (CSE 3210 - Mobile Application Development)
 * Authors: Md. Mahin Mia & Shakib Sharkar
 */

// Initial Mock Dataset for SMUCT Campus
const MOCK_DATA = {
  currentUser: {
    id: "usr_student_01",
    name: "Mahin Mia",
    email: "mahin.241071018@shanto-mariam.edu.bd",
    role: "student", // 'student', 'staff', 'admin'
    phone: "+880 1712-345678",
    studentId: "241071018",
    avatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80"
  },
  categories: [
    "All Categories",
    "Electronics",
    "Documents & IDs",
    "Bags & Wallets",
    "Accessories",
    "Books & Stationery",
    "Keys",
    "Clothing"
  ],
  locations: [
    "Main Campus Building",
    "Creative Technology Complex",
    "Central Library (3rd Floor)",
    "Campus Cafeteria",
    "CSE Computer Lab 2",
    "Auditorium Ground",
    "Faculty Room 402"
  ],
  items: [
    {
      id: "itm_001",
      title: "Student ID Card & Wallet",
      category: "Documents & IDs",
      status: "Found", // 'Lost' or 'Found'
      claimStatus: "Available", // 'Available', 'Pending', 'Claimed'
      location: "Central Library (3rd Floor)",
      datePosted: "2026-10-02",
      description: "Found a black leather wallet containing a SMUCT Student ID card (Batch 34th) near the study desk area.",
      imageUrl: "https://images.unsplash.com/photo-1627123424574-724758594e93?w=500&auto=format&fit=crop&q=80",
      authorId: "usr_staff_02",
      authorName: "Library Staff",
      contactPhone: "+880 1800-112233"
    },
    {
      id: "itm_002",
      title: "Apple AirPods Pro Case",
      category: "Electronics",
      status: "Lost",
      claimStatus: "Available",
      location: "Campus Cafeteria",
      datePosted: "2026-10-01",
      description: "Lost my white AirPods Pro charging case with a blue silicone sleeve during lunch hour around 1:30 PM.",
      imageUrl: "https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=500&auto=format&fit=crop&q=80",
      authorId: "usr_student_01",
      authorName: "Mahin Mia",
      contactPhone: "+880 1712-345678"
    },
    {
      id: "itm_003",
      title: "Casio Scientific Calculator fx-991EX",
      category: "Electronics",
      status: "Found",
      claimStatus: "Pending",
      location: "CSE Computer Lab 2",
      datePosted: "2026-09-30",
      description: "Left behind on Lab Table 14 after the afternoon Java programming lab session.",
      imageUrl: "https://images.unsplash.com/photo-1611125832047-1d7ad1e8e498?w=500&auto=format&fit=crop&q=80",
      authorId: "usr_teacher_01",
      authorName: "Shad Al Kaiser (Lecturer)",
      contactPhone: "+880 1900-556677"
    },
    {
      id: "itm_004",
      title: "Design Sketchbook & Pencils",
      category: "Books & Stationery",
      status: "Found",
      claimStatus: "Available",
      location: "Creative Technology Complex",
      datePosted: "2026-09-29",
      description: "A red A4 spiral sketchbook with fashion drawings inside. Found near Room 204.",
      imageUrl: "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500&auto=format&fit=crop&q=80",
      authorId: "usr_student_03",
      authorName: "Nusrat Jahan",
      contactPhone: "+880 1611-998877"
    }
  ],
  claims: [
    {
      id: "clm_101",
      itemId: "itm_003",
      itemTitle: "Casio Scientific Calculator fx-991EX",
      claimantId: "usr_student_01",
      claimantName: "Mahin Mia",
      claimantEmail: "mahin.241071018@shanto-mariam.edu.bd",
      justification: "It has my initials 'MM' scratched lightly on the battery cover back and a small yellow sticker.",
      dateSubmitted: "2026-10-02",
      status: "Pending" // 'Pending', 'Approved', 'Rejected'
    }
  ],
  notifications: [
    {
      id: "ntf_01",
      title: "Claim Submitted Successfully",
      message: "Your claim for 'Casio Scientific Calculator' is currently under Administrator review.",
      timestamp: "2 hours ago",
      read: false
    },
    {
      id: "ntf_02",
      title: "Welcome to SMUCT Lost & Found",
      message: "Easily report, search, and recover lost campus items with instant verification.",
      timestamp: "1 day ago",
      read: true
    }
  ],
  users: [
    { id: "usr_student_01", name: "Mahin Mia", email: "mahin.241071018@shanto-mariam.edu.bd", role: "Student", status: "Active" },
    { id: "usr_student_02", name: "Shakib Sharkar", email: "shakib.241071041@shanto-mariam.edu.bd", role: "Student", status: "Active" },
    { id: "usr_teacher_01", name: "Shad Al Kaiser", email: "kaiser@shanto-mariam.edu.bd", role: "Teacher", status: "Active" },
    { id: "usr_staff_02", name: "Library Desk Admin", email: "library@shanto-mariam.edu.bd", role: "Staff", status: "Active" },
    { id: "usr_bad_01", name: "Test Suspended User", email: "spammer@gmail.com", role: "Student", status: "Suspended" }
  ]
};

// Application State Engine
class App {
  constructor() {
    this.state = {
      role: 'student', // 'student' or 'admin'
      viewMode: 'mobile', // 'mobile' or 'fullscreen'
      currentView: 'feed', // 'feed', 'search', 'report', 'notifications', 'profile', 'detail', 'admin-dashboard', etc.
      activeCategory: 'All Categories',
      activeTab: 'All', // 'All', 'Lost', 'Found'
      searchQuery: '',
      selectedItem: null,
      claims: [...MOCK_DATA.claims],
      items: [...MOCK_DATA.items],
      notifications: [...MOCK_DATA.notifications],
      users: [...MOCK_DATA.users]
    };

    this.init();
  }

  init() {
    this.updateClock();
    setInterval(() => this.updateClock(), 30000);
    this.render();
  }

  updateClock() {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const mins = now.getMinutes().toString().padStart(2, '0');
    const clockEl = document.getElementById('clockTime');
    if (clockEl) clockEl.textContent = `${hours}:${mins}`;
  }

  setRole(role) {
    this.state.role = role;
    document.getElementById('roleStudentBtn').classList.toggle('active', role === 'student');
    document.getElementById('roleAdminBtn').classList.toggle('active', role === 'admin');

    const bottomNav = document.getElementById('bottomNav');
    const adminNav = document.getElementById('adminBottomNav');

    if (role === 'admin') {
      bottomNav.classList.add('hidden');
      adminNav.classList.remove('hidden');
      this.navigateTo('admin-dashboard');
    } else {
      adminNav.classList.add('hidden');
      bottomNav.classList.remove('hidden');
      this.navigateTo('feed');
    }
    this.showToast(`Switched to ${role.toUpperCase()} Role mode`);
  }

  setViewMode(mode) {
    this.state.viewMode = mode;
    const stage = document.getElementById('appStage');
    document.getElementById('viewMobileBtn').classList.toggle('active', mode === 'mobile');
    document.getElementById('viewFullBtn').classList.toggle('active', mode === 'fullscreen');

    if (mode === 'fullscreen') {
      stage.classList.add('fullscreen-mode');
    } else {
      stage.classList.remove('fullscreen-mode');
    }
  }

  navigateTo(view, payload = null) {
    this.state.currentView = view;
    if (payload) this.state.selectedItem = payload;

    // Update bottom nav active state
    const navButtons = document.querySelectorAll('.bottom-nav .nav-item');
    navButtons.forEach(btn => {
      btn.classList.toggle('active', btn.getAttribute('data-view') === view);
    });

    this.render();
  }

  // Master Render Method
  render() {
    const container = document.getElementById('appContent');
    container.innerHTML = '';

    switch (this.state.currentView) {
      case 'feed':
        container.appendChild(this.renderFeedView());
        break;
      case 'search':
        container.appendChild(this.renderSearchView());
        break;
      case 'report':
        container.appendChild(this.renderReportView());
        break;
      case 'detail':
        container.appendChild(this.renderDetailView());
        break;
      case 'notifications':
        container.appendChild(this.renderNotificationsView());
        break;
      case 'profile':
        container.appendChild(this.renderProfileView());
        break;
      case 'admin-dashboard':
        container.appendChild(this.renderAdminDashboard());
        break;
      case 'admin-claims':
        container.appendChild(this.renderAdminClaimsView());
        break;
      case 'admin-posts':
        container.appendChild(this.renderAdminPostsView());
        break;
      case 'admin-users':
        container.appendChild(this.renderAdminUsersView());
        break;
      default:
        container.appendChild(this.renderFeedView());
    }

    this.updateBadges();
  }

  updateBadges() {
    const pendingClaims = this.state.claims.filter(c => c.status === 'Pending').length;
    const unreadNotifs = this.state.notifications.filter(n => !n.read).length;

    const notifBadge = document.getElementById('notifBadge');
    if (notifBadge) notifBadge.classList.toggle('active', unreadNotifs > 0);

    const claimsBadge = document.getElementById('claimsBadge');
    if (claimsBadge) claimsBadge.classList.toggle('active', pendingClaims > 0);
  }

  // ------------------------------------------------------------------------
  // UC-05 / UC-06: Home Listing Feed Screen
  // ------------------------------------------------------------------------
  renderFeedView() {
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    // Header
    wrapper.innerHTML = `
      <div class="view-header">
        <div>
          <h2 class="view-title">SMUCT Feed</h2>
          <p class="view-subtitle">Campus Lost & Found Portal</p>
        </div>
        <div style="display:flex; align-items:center; gap: 0.5rem;">
          <span class="material-icons-round text-slate-400">notifications_none</span>
        </div>
      </div>

      <!-- Segmented Status Tabs -->
      <div class="segmented-tabs">
        <button class="tab-btn ${this.state.activeTab === 'All' ? 'active' : ''}" onclick="app.setTab('All')">All Items</button>
        <button class="tab-btn ${this.state.activeTab === 'Lost' ? 'active' : ''}" onclick="app.setTab('Lost')">Lost Items</button>
        <button class="tab-btn ${this.state.activeTab === 'Found' ? 'active' : ''}" onclick="app.setTab('Found')">Found Items</button>
      </div>

      <!-- Category Filter Chips -->
      <div class="filter-chips">
        ${MOCK_DATA.categories.map(cat => `
          <button class="chip ${this.state.activeCategory === cat ? 'active' : ''}" onclick="app.setCategory('${cat}')">
            ${cat}
          </button>
        `).join('')}
      </div>

      <!-- Item Grid -->
      <div class="item-list-container" id="itemList"></div>
    `;

    const itemListContainer = wrapper.querySelector('#itemList');
    itemListContainer.style.display = 'flex';
    itemListContainer.style.flexDirection = 'column';
    itemListContainer.style.gap = '1rem';

    // Filter Items Logic
    let filtered = this.state.items;
    if (this.state.activeTab !== 'All') {
      filtered = filtered.filter(i => i.status === this.state.activeTab);
    }
    if (this.state.activeCategory !== 'All Categories') {
      filtered = filtered.filter(i => i.category === this.state.activeCategory);
    }

    if (filtered.length === 0) {
      itemListContainer.innerHTML = `
        <div style="text-align:center; padding: 2rem 1rem; color: var(--text-muted);">
          <span class="material-icons-round" style="font-size:3rem; opacity:0.4;">search_off</span>
          <p style="margin-top:0.5rem; font-weight:600;">No items found in this category.</p>
        </div>
      `;
    } else {
      filtered.forEach(item => {
        itemListContainer.appendChild(this.createItemCard(item));
      });
    }

    return wrapper;
  }

  createItemCard(item) {
    const card = document.createElement('div');
    card.className = 'item-card';
    card.onclick = () => this.navigateTo('detail', item);

    const statusClass = item.status.toLowerCase();

    card.innerHTML = `
      <div style="position:relative;">
        <img src="${item.imageUrl}" alt="${item.title}" class="item-card-image">
        <span class="item-status-badge ${statusClass}">${item.status}</span>
        ${item.claimStatus === 'Claimed' ? `<span class="item-status-badge claimed" style="left:auto; right:10px;">CLAIMED</span>` : ''}
      </div>
      <div class="item-card-body">
        <h3 class="item-title">${item.title}</h3>
        <p class="item-desc-snippet">${item.description}</p>
        <div class="item-meta">
          <div class="item-meta-icon">
            <span class="material-icons-round text-xs">place</span>
            <span>${item.location}</span>
          </div>
          <div class="item-meta-icon">
            <span class="material-icons-round text-xs">schedule</span>
            <span>${item.datePosted}</span>
          </div>
        </div>
      </div>
    `;

    return card;
  }

  setTab(tab) {
    this.state.activeTab = tab;
    this.render();
  }

  setCategory(cat) {
    this.state.activeCategory = cat;
    this.render();
  }

  // ------------------------------------------------------------------------
  // UC-05: Search & Filter Screen
  // ------------------------------------------------------------------------
  renderSearchView() {
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div class="view-header">
        <h2 class="view-title">Search Listings</h2>
      </div>

      <div class="search-box">
        <span class="material-icons-round text-slate-400">search</span>
        <input type="text" class="search-input" id="searchInput" placeholder="Search keywords (e.g. ID, Wallet, Calculator)..." value="${this.state.searchQuery}">
        ${this.state.searchQuery ? `<span class="material-icons-round text-slate-400" style="cursor:pointer;" onclick="app.clearSearch()">close</span>` : ''}
      </div>

      <div class="filter-chips">
        ${MOCK_DATA.categories.map(cat => `
          <button class="chip ${this.state.activeCategory === cat ? 'active' : ''}" onclick="app.setCategory('${cat}')">${cat}</button>
        `).join('')}
      </div>

      <div id="searchResults" style="display:flex; flex-direction:column; gap:1rem;"></div>
    `;

    const searchInput = wrapper.querySelector('#searchInput');
    searchInput.oninput = (e) => {
      this.state.searchQuery = e.target.value;
      this.updateSearchResults(wrapper.querySelector('#searchResults'));
    };

    setTimeout(() => searchInput.focus(), 100);
    this.updateSearchResults(wrapper.querySelector('#searchResults'));

    return wrapper;
  }

  clearSearch() {
    this.state.searchQuery = '';
    this.render();
  }

  updateSearchResults(container) {
    if (!container) return;
    container.innerHTML = '';

    const query = this.state.searchQuery.toLowerCase().trim();
    let results = this.state.items;

    if (query) {
      results = results.filter(i => 
        i.title.toLowerCase().includes(query) || 
        i.description.toLowerCase().includes(query) ||
        i.location.toLowerCase().includes(query)
      );
    }

    if (this.state.activeCategory !== 'All Categories') {
      results = results.filter(i => i.category === this.state.activeCategory);
    }

    if (results.length === 0) {
      container.innerHTML = `
        <div style="text-align:center; padding: 2rem; color: var(--text-muted);">
          <p>No listings match your search criteria.</p>
        </div>
      `;
    } else {
      results.forEach(item => container.appendChild(this.createItemCard(item)));
    }
  }

  // ------------------------------------------------------------------------
  // UC-04: Report Lost / Found Item Screen
  // ------------------------------------------------------------------------
  renderReportView() {
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div class="view-header">
        <div>
          <h2 class="view-title">Report Item</h2>
          <p class="view-subtitle">Post a lost or found campus item</p>
        </div>
      </div>

      <form id="reportForm" style="display:flex; flex-direction:column; gap:1.1rem;" onsubmit="app.handleReportSubmit(event)">
        <!-- Status Toggle -->
        <div class="form-group">
          <label class="form-label">Report Type</label>
          <div class="segmented-tabs">
            <button type="button" class="tab-btn active" id="btnReportFound" onclick="app.setReportType('Found')">Found Something</button>
            <button type="button" class="tab-btn" id="btnReportLost" onclick="app.setReportType('Lost')">Lost Something</button>
          </div>
          <input type="hidden" id="reportType" value="Found">
        </div>

        <!-- Title -->
        <div class="form-group">
          <label class="form-label">Item Title *</label>
          <input type="text" id="reportTitle" class="form-input" placeholder="e.g. Blue HP Laptop Charger" required>
        </div>

        <!-- Category -->
        <div class="form-group">
          <label class="form-label">Category *</label>
          <select id="reportCategory" class="form-select" required>
            ${MOCK_DATA.categories.filter(c => c !== 'All Categories').map(c => `<option value="${c}">${c}</option>`).join('')}
          </select>
        </div>

        <!-- Location -->
        <div class="form-group">
          <label class="form-label">Campus Location *</label>
          <select id="reportLocation" class="form-select" required>
            ${MOCK_DATA.locations.map(loc => `<option value="${loc}">${loc}</option>`).join('')}
          </select>
        </div>

        <!-- Photograph Attachment (Simulation) -->
        <div class="form-group">
          <label class="form-label">Attach Photograph * (Max 5MB)</label>
          <div style="background:var(--card-bg); border:2px dashed var(--surface-border); border-radius:var(--radius-md); padding:1.2rem; text-align:center; cursor:pointer;" onclick="document.getElementById('fileUpload').click()">
            <span class="material-icons-round" style="font-size:2rem; color:var(--accent-cyan);">add_a_photo</span>
            <p style="font-size:0.8rem; margin-top:0.3rem; color:var(--text-muted);" id="fileNamePreview">Tap to upload photo or capture via camera</p>
          </div>
          <input type="file" id="fileUpload" accept="image/*" style="display:none;" onchange="app.handleFileSelect(event)">
        </div>

        <!-- Detailed Description -->
        <div class="form-group">
          <label class="form-label">Description & Distinct Features *</label>
          <textarea id="reportDesc" class="form-textarea" placeholder="Provide distinct features, color, brand, condition, or date details..." required></textarea>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn-primary">
          <span class="material-icons-round">publish</span>
          Publish Listing
        </button>
      </form>
    `;

    return wrapper;
  }

  setReportType(type) {
    document.getElementById('reportType').value = type;
    document.getElementById('btnReportFound').classList.toggle('active', type === 'Found');
    document.getElementById('btnReportLost').classList.toggle('active', type === 'Lost');
  }

  handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) {
      document.getElementById('fileNamePreview').textContent = `Selected: ${file.name} (${(file.size/1024/1024).toFixed(2)} MB)`;
    }
  }

  handleReportSubmit(event) {
    event.preventDefault();
    const title = document.getElementById('reportTitle').value;
    const category = document.getElementById('reportCategory').value;
    const location = document.getElementById('reportLocation').value;
    const desc = document.getElementById('reportDesc').value;
    const type = document.getElementById('reportType').value;

    const newItem = {
      id: "itm_" + Date.now(),
      title,
      category,
      status: type,
      claimStatus: "Available",
      location,
      datePosted: new Date().toISOString().split('T')[0],
      description: desc,
      imageUrl: type === 'Lost' ? 
        "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=500&auto=format&fit=crop&q=80" : 
        "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500&auto=format&fit=crop&q=80",
      authorId: MOCK_DATA.currentUser.id,
      authorName: MOCK_DATA.currentUser.name,
      contactPhone: MOCK_DATA.currentUser.phone
    };

    this.state.items.unshift(newItem);
    this.showToast(`Listing published: "${title}"`);
    this.navigateTo('feed');
  }

  // ------------------------------------------------------------------------
  // UC-07: Item Detail View & Claim Request Flow
  // ------------------------------------------------------------------------
  renderDetailView() {
    const item = this.state.selectedItem || this.state.items[0];
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    const statusClass = item.status.toLowerCase();

    wrapper.innerHTML = `
      <div style="display:flex; align-items:center; justify-content:space-between;">
        <button class="btn-secondary" style="width:auto; padding:0.4rem 0.8rem;" onclick="app.navigateTo('feed')">
          <span class="material-icons-round text-sm">arrow_back</span> Back
        </button>
        <span class="item-status-badge ${statusClass}">${item.status}</span>
      </div>

      <img src="${item.imageUrl}" class="detail-hero-img" alt="${item.title}">

      <div>
        <h2 class="view-title">${item.title}</h2>
        <p class="view-subtitle" style="margin-top:0.2rem;">Posted by ${item.authorName} on ${item.datePosted}</p>
      </div>

      <div class="meta-box-grid">
        <div class="meta-box">
          <span class="material-icons-round">category</span>
          <div>
            <div class="lbl">Category</div>
            <div class="val">${item.category}</div>
          </div>
        </div>
        <div class="meta-box">
          <span class="material-icons-round">place</span>
          <div>
            <div class="lbl">Location</div>
            <div class="val">${item.location}</div>
          </div>
        </div>
      </div>

      <div style="background:var(--card-bg); border:1px solid var(--surface-border); padding:1rem; border-radius:var(--radius-lg);">
        <h4 style="font-size:0.85rem; font-weight:700; color:var(--text-muted); margin-bottom:0.4rem;">Item Description</h4>
        <p style="font-size:0.88rem; line-height:1.5;">${item.description}</p>
      </div>

      <!-- Action Button for UC-07 Submit Claim Request -->
      ${item.status === 'Found' ? `
        ${item.claimStatus === 'Claimed' ? `
          <button class="btn-secondary" disabled style="opacity:0.6;">
            <span class="material-icons-round">check_circle</span> Item Claimed & Returned
          </button>
        ` : `
          <button class="btn-primary" onclick="app.openClaimModal('${item.id}')">
            <span class="material-icons-round">verified</span>
            Submit Claim Request
          </button>
        `}
      ` : `
        <button class="btn-secondary" onclick="app.showToast('Contacting Author: ' + '${item.contactPhone}')">
          <span class="material-icons-round">call</span>
          Contact Owner (${item.contactPhone})
        </button>
      `}
    `;

    return wrapper;
  }

  openClaimModal(itemId) {
    const item = this.state.items.find(i => i.id === itemId);
    const modal = document.getElementById('modalContainer');
    modal.classList.remove('hidden');

    modal.innerHTML = `
      <div class="modal-card">
        <div class="modal-header">
          <h3 style="font-family:var(--font-heading); font-weight:700; font-size:1.1rem;">Claim Verification Request</h3>
          <button class="close-btn" onclick="app.closeModal()">
            <span class="material-icons-round">close</span>
          </button>
        </div>

        <p style="font-size:0.8rem; color:var(--text-muted);">
          To claim <strong>${item.title}</strong>, please provide distinguishing features (e.g. markings, serial no, contents, exact date lost) to prove ownership.
        </p>

        <form onsubmit="app.handleClaimSubmit(event, '${item.id}')" style="display:flex; flex-direction:column; gap:0.9rem;">
          <div class="form-group">
            <label class="form-label">Ownership Proof / Justification *</label>
            <textarea id="claimJustification" class="form-textarea" placeholder="Describe unique features or contents..." required></textarea>
          </div>

          <button type="submit" class="btn-primary">
            <span class="material-icons-round">send</span>
            Submit Claim to Admin
          </button>
        </form>
      </div>
    `;
  }

  closeModal() {
    document.getElementById('modalContainer').classList.add('hidden');
  }

  handleClaimSubmit(event, itemId) {
    event.preventDefault();
    const justification = document.getElementById('claimJustification').value;
    const item = this.state.items.find(i => i.id === itemId);

    const newClaim = {
      id: "clm_" + Date.now(),
      itemId: item.id,
      itemTitle: item.title,
      claimantId: MOCK_DATA.currentUser.id,
      claimantName: MOCK_DATA.currentUser.name,
      claimantEmail: MOCK_DATA.currentUser.email,
      justification: justification,
      dateSubmitted: new Date().toISOString().split('T')[0],
      status: "Pending"
    };

    item.claimStatus = "Pending";
    this.state.claims.unshift(newClaim);
    
    // Add Notification
    this.state.notifications.unshift({
      id: "ntf_" + Date.now(),
      title: "Claim Submitted",
      message: `Claim for "${item.title}" has been submitted for Admin verification.`,
      timestamp: "Just now",
      read: false
    });

    this.closeModal();
    this.showToast("Claim request submitted to Administrator!");
    this.render();
  }

  // ------------------------------------------------------------------------
  // UC-09: Notifications Inbox
  // ------------------------------------------------------------------------
  renderNotificationsView() {
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div class="view-header">
        <h2 class="view-title">Notifications</h2>
      </div>

      <div style="display:flex; flex-direction:column; gap:0.75rem;">
        ${this.state.notifications.map(n => `
          <div style="background:var(--card-bg); border:1px solid var(--surface-border); padding:1rem; border-radius:var(--radius-md); border-left:4px solid var(--accent-cyan);">
            <h4 style="font-size:0.9rem; font-weight:700;">${n.title}</h4>
            <p style="font-size:0.8rem; color:var(--text-muted); margin-top:0.25rem;">${n.message}</p>
            <span style="font-size:0.7rem; color:var(--text-subtle); display:block; margin-top:0.4rem;">${n.timestamp}</span>
          </div>
        `).join('')}
      </div>
    `;

    return wrapper;
  }

  // ------------------------------------------------------------------------
  // UC-03 & UC-08: User Profile & My Posts
  // ------------------------------------------------------------------------
  renderProfileView() {
    const u = MOCK_DATA.currentUser;
    const myPosts = this.state.items.filter(i => i.authorId === u.id);

    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div style="text-align:center; padding:1rem 0;">
        <img src="${u.avatar}" style="width:80px; height:80px; border-radius:50%; object-fit:cover; border:3px solid var(--accent-cyan);" alt="Profile">
        <h2 style="font-family:var(--font-heading); font-weight:700; font-size:1.2rem; margin-top:0.5rem;">${u.name}</h2>
        <p style="font-size:0.8rem; color:var(--text-muted);">${u.email}</p>
        <span class="chip active" style="margin-top:0.5rem; display:inline-block;">Student ID: ${u.studentId}</span>
      </div>

      <div>
        <h3 style="font-size:0.95rem; font-weight:700; margin-bottom:0.75rem;">My Reported Items (${myPosts.length})</h3>
        <div style="display:flex; flex-direction:column; gap:0.75rem;">
          ${myPosts.map(item => `
            <div style="background:var(--card-bg); border:1px solid var(--surface-border); padding:0.75rem; border-radius:var(--radius-md); display:flex; justify-content:space-between; align-items:center;">
              <div>
                <h4 style="font-size:0.85rem; font-weight:700;">${item.title}</h4>
                <span style="font-size:0.72rem; color:var(--text-muted);">${item.status} • ${item.datePosted}</span>
              </div>
              <button class="btn-danger" style="padding:0.3rem 0.6rem; font-size:0.72rem;" onclick="app.deletePost('${item.id}')">Delete</button>
            </div>
          `).join('')}
        </div>
      </div>
    `;

    return wrapper;
  }

  deletePost(itemId) {
    this.state.items = this.state.items.filter(i => i.id !== itemId);
    this.showToast("Post deleted");
    this.render();
  }

  // ------------------------------------------------------------------------
  // UC-10, UC-11, UC-12, UC-13: ADMINISTRATOR DASHBOARD
  // ------------------------------------------------------------------------
  renderAdminDashboard() {
    const totalItems = this.state.items.length;
    const lostCount = this.state.items.filter(i => i.status === 'Lost').length;
    const foundCount = this.state.items.filter(i => i.status === 'Found').length;
    const pendingClaims = this.state.claims.filter(c => c.status === 'Pending').length;

    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div class="view-header">
        <div>
          <h2 class="view-title">Admin Dashboard</h2>
          <p class="view-subtitle">SMUCT Platform Governance</p>
        </div>
      </div>

      <!-- UC-13 Platform Statistics -->
      <div class="stats-grid">
        <div class="stat-card">
          <span class="stat-num">${totalItems}</span>
          <span class="stat-label">Total Listings</span>
        </div>
        <div class="stat-card">
          <span class="stat-num" style="color:var(--tag-lost);">${lostCount}</span>
          <span class="stat-label">Lost Reports</span>
        </div>
        <div class="stat-card">
          <span class="stat-num" style="color:var(--tag-found);">${foundCount}</span>
          <span class="stat-label">Found Reports</span>
        </div>
        <div class="stat-card">
          <span class="stat-num" style="color:var(--tag-pending);">${pendingClaims}</span>
          <span class="stat-label">Pending Claims</span>
        </div>
      </div>

      <!-- Admin Quick Navigation -->
      <div style="display:flex; flex-direction:column; gap:0.75rem; margin-top:0.5rem;">
        <button class="btn-primary" onclick="app.navigateTo('admin-claims')">
          <span class="material-icons-round">gavel</span>
          Adjudicate Claims (${pendingClaims})
        </button>
        <button class="btn-secondary" onclick="app.navigateTo('admin-users')">
          <span class="material-icons-round">group</span>
          Manage Users (${this.state.users.length})
        </button>
      </div>
    `;

    return wrapper;
  }

  // UC-12: Approve / Reject Claims Adjudication Queue
  renderAdminClaimsView() {
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div class="view-header">
        <h2 class="view-title">Adjudicate Claims (UC-12)</h2>
      </div>

      <div style="display:flex; flex-direction:column; gap:1rem;">
        ${this.state.claims.map(claim => `
          <div style="background:var(--card-bg); border:1px solid var(--surface-border); border-radius:var(--radius-lg); padding:1rem;">
            <div style="display:flex; justify-content:space-between; align-items:center;">
              <h4 style="font-size:0.92rem; font-weight:700;">${claim.itemTitle}</h4>
              <span class="item-status-badge ${claim.status === 'Pending' ? 'claimed' : claim.status.toLowerCase()}">${claim.status}</span>
            </div>

            <p style="font-size:0.78rem; color:var(--text-muted); margin-top:0.3rem;">
              <strong>Claimant:</strong> ${claim.claimantName} (${claim.claimantEmail})
            </p>

            <div style="background:rgba(255,255,255,0.03); border:1px solid var(--surface-border); padding:0.6rem; border-radius:var(--radius-sm); margin:0.6rem 0; font-size:0.8rem;">
              <strong>Justification Statement:</strong> "${claim.justification}"
            </div>

            ${claim.status === 'Pending' ? `
              <div style="display:flex; gap:0.5rem;">
                <button class="btn-success" style="flex:1;" onclick="app.adjudicateClaim('${claim.id}', 'Approved')">Approve Claim</button>
                <button class="btn-danger" style="flex:1;" onclick="app.adjudicateClaim('${claim.id}', 'Rejected')">Reject Claim</button>
              </div>
            ` : ''}
          </div>
        `).join('')}
      </div>
    `;

    return wrapper;
  }

  adjudicateClaim(claimId, outcome) {
    const claim = this.state.claims.find(c => c.id === claimId);
    if (!claim) return;

    claim.status = outcome;
    if (outcome === 'Approved') {
      const item = this.state.items.find(i => i.id === claim.itemId);
      if (item) item.claimStatus = 'Claimed';
    }

    this.showToast(`Claim ${outcome} for ${claim.itemTitle}`);
    this.render();
  }

  // UC-11: Moderate Posts
  renderAdminPostsView() {
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div class="view-header">
        <h2 class="view-title">Moderate Posts (UC-11)</h2>
      </div>

      <div style="display:flex; flex-direction:column; gap:0.75rem;">
        ${this.state.items.map(item => `
          <div style="background:var(--card-bg); border:1px solid var(--surface-border); padding:0.85rem; border-radius:var(--radius-md); display:flex; justify-content:space-between; align-items:center;">
            <div>
              <h4 style="font-size:0.88rem; font-weight:700;">${item.title}</h4>
              <span style="font-size:0.75rem; color:var(--text-muted);">${item.category} • Posted by ${item.authorName}</span>
            </div>
            <button class="btn-danger" style="padding:0.35rem 0.7rem; font-size:0.75rem;" onclick="app.deletePost('${item.id}')">Remove</button>
          </div>
        `).join('')}
      </div>
    `;

    return wrapper;
  }

  // UC-10: User Account Moderation
  renderAdminUsersView() {
    const wrapper = document.createElement('div');
    wrapper.className = 'screen-view';

    wrapper.innerHTML = `
      <div class="view-header">
        <h2 class="view-title">Manage Users (UC-10)</h2>
      </div>

      <div style="display:flex; flex-direction:column; gap:0.75rem;">
        ${this.state.users.map(u => `
          <div style="background:var(--card-bg); border:1px solid var(--surface-border); padding:0.85rem; border-radius:var(--radius-md); display:flex; justify-content:space-between; align-items:center;">
            <div>
              <h4 style="font-size:0.88rem; font-weight:700;">${u.name} (${u.role})</h4>
              <span style="font-size:0.75rem; color:var(--text-muted);">${u.email}</span>
            </div>
            <button class="${u.status === 'Active' ? 'btn-danger' : 'btn-success'}" style="padding:0.35rem 0.7rem; font-size:0.75rem;" onclick="app.toggleUserStatus('${u.id}')">
              ${u.status === 'Active' ? 'Suspend' : 'Activate'}
            </button>
          </div>
        `).join('')}
      </div>
    `;

    return wrapper;
  }

  toggleUserStatus(userId) {
    const user = this.state.users.find(u => u.id === userId);
    if (!user) return;
    user.status = user.status === 'Active' ? 'Suspended' : 'Active';
    this.showToast(`User ${user.name} is now ${user.status}`);
    this.render();
  }

  // Toast Notification System Helper
  showToast(msg) {
    const container = document.getElementById('toastContainer');
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = `<span class="material-icons-round">info</span> ${msg}`;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3500);
  }
}

// Global App Instance
window.app = new App();
