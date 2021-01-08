import 'package:flutter/material.dart';
import 'package:duochat/models.dart';

class UserSearch extends SearchDelegate<String> {
	
	final List<PublicUserData> _users = [
		PublicUserData(name: 'Kitty', id: '1', photoURL: 'https://i.imgur.com/O9z1hcx.png', username: 'ghost_cat'),
		PublicUserData(name: 'Cat', id: '2', photoURL: 'https://i.imgur.com/UYcL5sl.jpg', username: 'paint_cat'),
		PublicUserData(name: 'Space Planet', id: '3', photoURL: 'https://i.imgur.com/ftmga3Y.png', username: 'red_planet'),
		PublicUserData(name: 'Space Galaxy', id: '4', photoURL: 'https://i.imgur.com/drDF2xB.jpg', username: 'milkyway'),
		PublicUserData(name: 'Random Girl', id: '5', photoURL: 'https://i.imgur.com/6xFjIVa.jpg', username: 'commonapp_girl'),
		PublicUserData(name: 'Dino', id: '6', photoURL: 'https://i.imgur.com/Vaoll5X.png', username: 'Dio'),
	];
	
	// textfield layout:
//	Container(
//	margin: EdgeInsets.all(16.0),
//	child: TextField(
//	decoration: InputDecoration(
//	prefixIcon: Padding(
//	padding: const EdgeInsets.only(left: 12.0, right: 8.0),
//	child: Icon(
//	Icons.search,
//	color: Colors.black87,
//	size: 24.0,
//	),
//	),
//	prefixIconConstraints: BoxConstraints(),
//	contentPadding:
//	EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
//	isDense: true,
//	hintText: 'Search',
//	border: OutlineInputBorder(
//	borderRadius: BorderRadius.all(Radius.circular(200.0)),
//	),
//	),
//	onChanged: (text) {
//	print('Search: $text');
//	},
//	),
//	),
	
	
	
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: connect buildResults with firebase
	
	  if(query.isEmpty) {
		  return Container(child: Text('You gotta search something (maybe just list recommendations here)'));
	  } else {
		  List<PublicUserData> results = _users
			  .where((user) =>
		  user.name.toLowerCase().contains(query.toLowerCase()) ||
			  user.username.toLowerCase().contains(query.toLowerCase())).toList();
		
		  return ListView.builder(
			  itemCount: results.length,
			  itemBuilder: (BuildContext context, int index) {
				  return GestureDetector(
					  onTap: () => print('Tapped user: ${results[index].username}'),
					  child: _UserCard(user: results[index])
				  );
			  }
		  );
	  }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: connect buildSuggestions with firebase
	  
	  if(query.isEmpty) {
		  return Container(child: Text('Suggestions (maybe show search history?)'));
	  } else {
		  List<PublicUserData> suggestions = _users
			  .where((user) => user.name.toLowerCase().contains(query.toLowerCase()) ||
			  user.username.toLowerCase().contains(query.toLowerCase())).toList();
		  return ListView.builder(
			  itemCount: suggestions.length,
			  itemBuilder: (BuildContext context, int index) {
				  return ListTile(
					  title: Text(suggestions[index].name),
					  onTap: () => print('Selected user: ${suggestions[index].username}'),
				  );
			  },
		  );
	  }
	  
	  
  }
}

class _UserCard extends StatelessWidget {
	
	const _UserCard({@required this.user});
	
	final PublicUserData user;
	
	
	@override
	Widget build(BuildContext context) {
		return Container(
			margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
			padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
			decoration: BoxDecoration(
				gradient: LinearGradient(
					colors: [const Color(0xFFFFFFEF), const Color(0xFFffd4d1)],
				),
				borderRadius: BorderRadius.horizontal(
					right: Radius.circular(25.0),
				),
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: <Widget>[
					Row(
						children: <Widget>[
							CircleAvatar(
								radius: 35.0,
								backgroundImage: NetworkImage(user.photoURL),
							),
							SizedBox(width: 15.0),
							Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									Text(
										user.name,
										style: TextStyle(
											color: Colors.grey,
											fontSize: 15.0,
											fontWeight: FontWeight.bold,
										),
									),
									SizedBox(
										height: 5.0,
									),
									Container(
										width: MediaQuery.of(context).size.width - 210,
										child: Text(
											user.username,
											style: TextStyle(
												color: Colors.blueGrey,
												fontSize: 15.0,
												fontWeight: FontWeight.w600,
											),
											overflow: TextOverflow.ellipsis,
										),
									),
								],
							)
						],
					),
				],
			),
		);
	}
	
}