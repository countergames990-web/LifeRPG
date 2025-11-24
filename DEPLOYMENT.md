# 🚀 Deployment Guide for Life RPG

## Quick Start - Deploy to Netlify in 5 Minutes

### Prerequisites
✅ Flutter SDK installed
✅ Netlify account (free at netlify.com)

### Step 1: Build the Project

Open terminal in the project root and run:

```bash
flutter build web --release
```

This will create a `build/web` folder with your compiled application.

### Step 2: Deploy to Netlify

#### Option A: Drag & Drop (Simplest)

1. Go to https://app.netlify.com
2. Log in or create a free account
3. Click "Add new site" → "Deploy manually"
4. Drag the entire `build/web` folder onto the upload area
5. Done! Your app is now live!

Your app will be available at: `https://[random-name].netlify.app`

#### Option B: Connect to GitHub (Recommended for Updates)

1. Push your code to GitHub:
```bash
git init
git add .
git commit -m "Initial commit - Life RPG"
git branch -M main
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

2. Go to https://app.netlify.com
3. Click "Add new site" → "Import an existing project"
4. Choose "GitHub" and authorize
5. Select your repository
6. Configure build settings:
   - **Build command**: `flutter build web --release`
   - **Publish directory**: `build/web`
7. Click "Deploy site"

Netlify will automatically rebuild and deploy whenever you push to GitHub!

### Step 3: Custom Domain (Optional)

1. In Netlify dashboard, go to "Domain settings"
2. Click "Add custom domain"
3. Follow instructions to connect your domain

## Testing Your Deployment

Once deployed, test these features:

- [ ] Profile page loads correctly
- [ ] Character switcher works
- [ ] Daily score update saves and persists
- [ ] Weekly stats display graphs
- [ ] Story page tabs work and save content
- [ ] Animated background displays
- [ ] Refresh page - data should persist

## Data Persistence

### Important Notes:

1. **localStorage**: Data is stored in browser localStorage
2. **Per-Browser**: Each browser has its own copy
3. **Same URL**: Both you and your girlfriend should bookmark the SAME Netlify URL
4. **Same Device Preferred**: For best sync experience, use the same device or...

### Sharing Between Devices:

**Option 1: Same Netlify URL** (Simplest)
- Both access: `https://your-app.netlify.app`
- You'll see each other's updates when refreshing the page

**Option 2: Manual Sync** (For different devices)
- Export data feature (to be implemented)
- Share JSON file
- Import on other device

**Option 3: Real-time Sync** (Future Enhancement)
- Could add Firebase
- Could use GitHub as database
- Could create simple backend API

## Updating Your App

### If you used GitHub integration:

```bash
# Make your changes to the code
git add .
git commit -m "Added new feature"
git push
```

Netlify automatically rebuilds and deploys!

### If you used drag & drop:

```bash
# Build again
flutter build web --release

# Go to Netlify, click "Deploys" tab
# Drag & drop the new build/web folder
```

## Common Issues & Solutions

### Issue: App doesn't load
**Solution**: Check browser console (F12) for errors. Make sure you're using a modern browser (Chrome, Edge, Firefox).

### Issue: Data doesn't persist
**Solution**: 
- Check if browser allows localStorage
- Don't use incognito/private mode
- Try clearing cache: Ctrl+Shift+Delete

### Issue: Changes not reflecting after update
**Solution**: Hard refresh the page: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

### Issue: Build fails
**Solution**:
```bash
flutter clean
flutter pub get
flutter build web --release
```

## Performance Optimization

For faster loading:

1. **Minimize animations**: Edit `lib/widgets/animated_background.dart`
2. **Optimize images**: Compress character images before uploading
3. **Enable caching**: Already configured in `netlify.toml`

## Security Notes

- No sensitive data is stored
- All data stays in browser localStorage
- HTTPS is automatic with Netlify
- Headers configured for basic security in `netlify.toml`

## Future Enhancements to Consider

Once deployed and tested:

1. **Custom cursor**: Medieval sword/quill pointer
2. **Sound effects**: Background music and click sounds
3. **Export/Import**: Backup and restore functionality
4. **Mobile responsive**: Better mobile layout
5. **PWA**: Install as app on phone
6. **Dark mode**: Toggle for night use
7. **Notifications**: Daily reminders to update scores

## Cost

**Everything is FREE:**
- ✅ Netlify: Free tier includes 100GB bandwidth/month
- ✅ Flutter: Free and open source
- ✅ GitHub: Free for public repos
- ✅ Domain (optional): ~$10-15/year if you want custom domain

## Support

If you encounter issues:

1. Check browser console (F12)
2. Review the README.md
3. Check Flutter web compatibility
4. Verify Netlify build logs

## Maintenance

### Weekly:
- Test that everything works
- Back up data (export feature - to be added)

### Monthly:
- Check for Flutter updates
- Review Netlify analytics

### As Needed:
- Add new features
- Update character images
- Expand story content

---

**🎉 Enjoy your Life RPG adventure together!**

Remember: The goal is to have fun tracking your life together in a creative, gamified way. Don't stress about perfect scores - it's about the journey!
