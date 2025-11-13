"""
Quick test script to verify backend is working
Run this after starting the backend server
"""

import requests
import json

BACKEND_URL = "http://localhost:5000"

def test_health():
    """Test health endpoint"""
    print("\n1️⃣ Testing health endpoint...")
    try:
        response = requests.get(f"{BACKEND_URL}/health", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Backend healthy: {data['message']}")
            print(f"   ✅ API key configured: {data['api_key_configured']}")
            return True
        else:
            print(f"   ❌ Health check failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"   ❌ Backend not reachable: {e}")
        print("   💡 Make sure to run: python backend/server.py")
        return False


def test_fetch_slugs():
    """Test fetching scheme slugs"""
    print("\n2️⃣ Testing scheme slugs endpoint...")
    try:
        response = requests.get(f"{BACKEND_URL}/api/schemes?size=5", timeout=10)
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Total schemes available: {data['total']}")
            print(f"   ✅ Returned {data['returned']} slugs")
            print(f"   📋 Sample slugs: {data['slugs'][:3]}")
            return data['slugs'][:3]  # Return first 3 slugs for testing
        else:
            print(f"   ❌ Failed to fetch slugs: {response.status_code}")
            return []
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return []


def test_fetch_scheme(slug):
    """Test fetching a specific scheme"""
    print(f"\n3️⃣ Testing scheme details endpoint (slug: {slug})...")
    try:
        response = requests.get(f"{BACKEND_URL}/api/scheme/{slug}", timeout=15)
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Scheme loaded successfully")
            print(f"   📌 Title: {data['title']}")
            print(f"   📌 Ministry: {data['ministry']}")
            print(f"   📌 Documents: {len(data.get('documents', []))} required")
            print(f"   📌 FAQs: {len(data.get('faqs', []))} available")
            return True
        else:
            print(f"   ❌ Failed to fetch scheme: {response.status_code}")
            return False
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False


def test_batch_fetch(slugs):
    """Test batch fetching multiple schemes"""
    print(f"\n4️⃣ Testing batch endpoint ({len(slugs)} schemes)...")
    try:
        response = requests.post(
            f"{BACKEND_URL}/api/schemes/batch",
            json={"slugs": slugs},
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Batch fetch successful")
            print(f"   📌 Requested: {data['requested']} schemes")
            print(f"   📌 Returned: {data['total']} schemes")
            return True
        else:
            print(f"   ❌ Batch fetch failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False


def main():
    print("="*60)
    print("🧪 Backend API Test Suite")
    print("="*60)
    
    # Test 1: Health check
    if not test_health():
        print("\n❌ Backend not running. Start it first:")
        print("   python backend/server.py")
        return
    
    # Test 2: Fetch slugs
    slugs = test_fetch_slugs()
    if not slugs:
        print("\n❌ Could not fetch slugs. Check API key or network.")
        return
    
    # Test 3: Fetch specific scheme
    test_fetch_scheme(slugs[0])
    
    # Test 4: Batch fetch
    test_batch_fetch(slugs)
    
    print("\n" + "="*60)
    print("✅ All tests completed!")
    print("="*60)
    print("\n📱 Your Flutter app can now use BackendApiService")
    print("   Example: await backendApi.fetchAllSchemes(limit: 10)")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
