import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// 插画数据模型（使用本地路径）
class Illustration {
  final String id;
  final String title;
  final String artist;
  final String imagePath; // 使用本地路径而非URL
  final List<String> tags;

  Illustration({
    required this.id,
    required this.title,
    required this.artist,
    required this.imagePath,
    required this.tags,
  });
}

// 模拟的插画数据
final List<Illustration> illustrations = [
  Illustration(
    id: '1',
    title: '山水风光',
    artist: '画师JW',
    imagePath: 'images/beauty_01.jpg',
    tags: ['风景', '山水', '唯美'],
  ),
  Illustration(
    id: '2',
    title: '动漫人物',
    artist: '出水ぽすか',
    imagePath: 'images/beauty_02.jpg',
    tags: ['人物', '动漫', '萌系'],
  ),
  Illustration(
    id: '3',
    title: '未来海底',
    artist: 'Lifeline',
    imagePath: 'images/beauty_03.jpg',
    tags: ['科幻', '未来', '海洋'],
  ),
  Illustration(
    id: '4',
    title: '梦幻河流',
    artist: 'Miv4t',
    imagePath: 'images/beauty_04.jpg',
    tags: ['艺术', '河流', '梦幻'],
  ),
  Illustration(
    id: '5',
    title: '城市幻想',
    artist: '壱珂',
    imagePath: 'images/beauty_05.jpg',
    tags: ['城市', '少女', '幻想'],
  ),
  Illustration(
    id: '6',
    title: '废土科技',
    artist: 'Rotarran',
    imagePath: 'images/beauty_06.jpg',
    tags: ['废土', '科技', '孤独'],
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // 顶部渐变搜索栏
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  title: const Text('精选插画集'),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: IllustrationSearchDelegate(illustrations),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '搜索插画作品...',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: IllustrationSearchDelegate(illustrations),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // 插画网格
          const Expanded(child: IllustrationsGrid()),
        ],
      ),
    );
  }
}

class IllustrationsGrid extends StatelessWidget {
  const IllustrationsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: illustrations.length,
      itemBuilder: (context, index) {
        final illustration = illustrations[index];
        return IllustrationCard(illustration: illustration);
      },
    );
  }
}

class IllustrationCard extends StatelessWidget {
  final Illustration illustration;

  const IllustrationCard({Key? key, required this.illustration})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        IllustrationDetailScreen(illustration: illustration),
                  ),
                );
              },
              // 加载本地图片
              child: FadeInImage(
                placeholder: const AssetImage('./images/loading.jpg'),
                image: AssetImage(illustration.imagePath),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error_outline, color: Colors.red),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  illustration.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  illustration.artist,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IllustrationDetailScreen extends StatelessWidget {
  final Illustration illustration;

  const IllustrationDetailScreen({Key? key, required this.illustration})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('已收藏该插画')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('图片已保存到相册')));
            },
          ),
        ],
      ),
      body: Center(
        // 加载本地图片（支持缩放）
        child: PhotoView(
          imageProvider: AssetImage(illustration.imagePath),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 5,
          enableRotation: false,
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded /
                        (event.expectedTotalBytes ?? 1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              illustration.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '作者: ${illustration.artist}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: illustration.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('images/avatar.jpg'),
                ),
                const SizedBox(height: 10),
                Text(
                  '插画爱好者',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  'xxx@example.com',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('首页'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('收藏'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('收藏功能将在未来版本中推出')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('下载'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('下载功能将在未来版本中推出')));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('设置功能将在未来版本中推出')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: '精选插画集',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2023 插画集应用',
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('发现和收藏精美的插画作品'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class IllustrationSearchDelegate extends SearchDelegate<Illustration?> {
  final List<Illustration> illustrations;

  IllustrationSearchDelegate(this.illustrations);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = illustrations.where((illustration) {
      final titleMatch = illustration.title.toLowerCase().contains(
        query.toLowerCase(),
      );
      final artistMatch = illustration.artist.toLowerCase().contains(
        query.toLowerCase(),
      );
      final tagMatch = illustration.tags.any(
        (tag) => tag.toLowerCase().contains(query.toLowerCase()),
      );
      return titleMatch || artistMatch || tagMatch;
    }).toList();
    return IllustrationsSearchResults(results: results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('请输入搜索内容'));
    }
    final suggestions = illustrations.where((illustration) {
      final titleMatch = illustration.title.toLowerCase().contains(
        query.toLowerCase(),
      );
      final artistMatch = illustration.artist.toLowerCase().contains(
        query.toLowerCase(),
      );
      return titleMatch || artistMatch;
    }).toList();
    return IllustrationsSearchResults(results: suggestions);
  }
}

class IllustrationsSearchResults extends StatelessWidget {
  final List<Illustration> results;

  const IllustrationsSearchResults({Key? key, required this.results})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(child: Text('未找到相关插画'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final illustration = results[index];
        return IllustrationCard(illustration: illustration);
      },
    );
  }
}
